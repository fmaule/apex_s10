global function WhatsNewPanel_Init

#if UI
struct {
	var		panel
	var		headerRui
	var		listPanel
	var		actionButton
	bool	hideUnlocked
	ItemFlavor ornull activeItem
	table<var, ItemFlavor> activeItemButtons = {}
	bool isXButtonRegistered
	bool isUnlockOperationActive
	array<ItemFlavor> whatsNewList
	bool hasAssetListsBeenVerified = false
	string associatedPackName
	string itemSourceIcon
} file

table< int, string > previewSoundMap = {
	[eItemType.character_skin] 				= "UI_Menu_LegendSkin_Preview",
	[eItemType.character_execution] 		= "UI_Menu_Finisher_Preview",
	[eItemType.gladiator_card_frame] 		= "UI_Menu_Banner_Preview",
	[eItemType.gladiator_card_stance] 		= "UI_Menu_Banner_Preview",
	[eItemType.gladiator_card_badge] 		= "UI_Menu_Banner_Preview",
	[eItemType.gladiator_card_stat_tracker] = "UI_Menu_Banner_Preview",
	[eItemType.gladiator_card_intro_quip] 	= "UI_Menu_Quip_Preview",
	[eItemType.gladiator_card_kill_quip] 	= "UI_Menu_Quip_Preview",
	[eItemType.weapon_skin] 				= "UI_Menu_WeaponSkin_Preview"
}
#endif

void function WhatsNewPanel_Init( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, WhatsNewPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, WhatsNewPanel_OnHide )

	SetPanelTabTitle( panel, Localize( "MENU_STORE_PANEL_THEMATIC_EVENT" ) )
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )
	RuiSetString( file.headerRui, "title", Localize( "#OWNED" ).toupper() )

	file.listPanel = Hud_GetChild( panel, "WhatsNewList" )

	file.hideUnlocked = false
	var hideLockedButton = Hud_GetChild( file.panel, "ToggleHideShowLocked" )
	HudElem_SetRuiArg( hideLockedButton, "showAll", true )
	Hud_AddEventHandler( hideLockedButton, UIE_CLICK, ToggleHideShowLockedItems )

	AddUICallback_InputModeChanged( OnInputModeChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, WhatsNew_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, WhatsNew_IsFocusedItemLocked )
}

void function WhatsNewPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	WhatsNewPanel_Update( panel )
}

void function WhatsNewPanel_OnHide( var panel )
{
	WhatsNewPanel_Update( panel )
}

void function ToggleHideShowLockedItems( var button )
{
	file.hideUnlocked = !file.hideUnlocked
	WhatsNewPanel_Update( Hud_GetParent( button ) )
	Hud_ScrollToTop( file.listPanel )
}

int function SortItemFlavByGUID_Callback( ItemFlavor lhs, ItemFlavor rhs )
{
	SettingsAssetGUID lhsGUID = ItemFlavor_GetGUID( lhs )
	SettingsAssetGUID rhsGUID = ItemFlavor_GetGUID( rhs )

	if ( lhsGUID < rhsGUID )
		return -1
	else if ( lhsGUID > rhsGUID )
		return 1

	return 0
}

void function WhatsNewPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	var hideLockedButton = Hud_GetChild( file.panel, "ToggleHideShowLocked" )
	HudElem_SetRuiArg( hideLockedButton, "showAll", file.hideUnlocked ? false : true  )

	         
	foreach ( int flavIdx, ItemFlavor unused in file.whatsNewList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		WhatsNewRemoveItemButton( button )
	}
	file.whatsNewList.clear()
	file.activeItem = null
	WhatsNewSetActionButton( null )

	if ( IsValid( file.panel ) && IsPanelActive( file.panel ) )
	{
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )

		if ( activeThemedShopEvent == null )
			return

		if ( !ThemedShopEvent_HasWhatsNew( expect ItemFlavor( activeThemedShopEvent ) ) )
			return

		asset eventItemList = ThemedShopEvent_GetWhatsNewList( expect ItemFlavor( activeThemedShopEvent ) )
		var assetBlock		= GetSettingsBlockForAsset( eventItemList )
		foreach ( var entryBlock in IterateSettingsArray( GetSettingsBlockArray( assetBlock, "list" ) ) )
		{
			asset entryAsset = GetSettingsBlockAsset( entryBlock, "flavor" )
			if ( IsValidItemFlavorSettingsAsset( entryAsset ) )
				file.whatsNewList.append( GetItemFlavorByAsset( entryAsset ) )
		}

		ItemFlavor associatedEventPack = GetItemFlavorByAsset( GetGlobalSettingsAsset( eventItemList, "associatedPackFlav" ) )
		WhatsNewSetActionButton( Hud_GetChild( panel, "ActionButton" ) )
		HudElem_SetRuiArg( file.actionButton, "rarityIcon", GRXPack_GetOpenButtonIcon( associatedEventPack ) )
		file.associatedPackName = Localize( ItemFlavor_GetShortName( associatedEventPack ) )
		file.itemSourceIcon = "%$" + string( ItemFlavor_GetSourceIcon( associatedEventPack ) ) + "%"                                                                          

#if DEV
		if ( !file.hasAssetListsBeenVerified )
		{
			array<ItemFlavor> packContents = GRXPack_GetPackContents( associatedEventPack )
			Assert( packContents.len() > 0 )
			Assert( packContents.len() == file.whatsNewList.len(), "The \"What's New\" panel and the pack for " + ItemFlavor_GetHumanReadableRef( associatedEventPack ) + " do not agree on the number of items in the collection" )

			array<ItemFlavor> sortedWhatsNewList = clone file.whatsNewList;

			packContents.sort( SortItemFlavByGUID_Callback )
			sortedWhatsNewList.sort( SortItemFlavByGUID_Callback )

			for ( int i = 0; i < packContents.len(); ++i )
				Assert( ItemFlavor_GetGUID( packContents[i] ) == ItemFlavor_GetGUID( sortedWhatsNewList[i] ), "Item list disagreement! The \"What's New\" panel has " + ItemFlavor_GetHumanReadableRef( sortedWhatsNewList[i] ) + "but the pack for " + ItemFlavor_GetHumanReadableRef( associatedEventPack ) + " has " + ItemFlavor_GetHumanReadableRef( packContents[i] ) )

			file.hasAssetListsBeenVerified = true
		}
#endif

		int numOwnedItems	= FilterOwnedItems( file.whatsNewList )
		int totalItems 		= file.hideUnlocked ? file.whatsNewList.len() + numOwnedItems : file.whatsNewList.len()
		SortWhatsNewList( file.whatsNewList )

		Hud_InitGridButtons( file.listPanel, file.whatsNewList.len() )

		foreach ( int flavIdx, ItemFlavor flav in file.whatsNewList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )

			var rui = Hud_GetRui( button )

			RuiSetBool( rui, "isLocked", !IsItemOwned( flav ) )
			RuiSetImage( rui, "itemThumbnail", CustomizeMenu_GetRewardButtonImage( flav ) )
			RuiSetString( rui, "buttonText", Localize( ItemFlavor_GetLongName( flav ) ) )
			RuiSetInt( rui, "quality", ItemFlavor_HasQuality( flav ) ? ItemFlavor_GetQuality( flav ) : 0 )

			WhatsNewSetupItemButton( button, flav)

			if ( flavIdx == 0 )                                         
			{
				UpdateActionContext( button )
				Hud_SetSelected( button, true )
				PreviewItem( flav )
			}
			else
			{
				Hud_SetSelected( button, false )
			}
		}
		RuiSetString( file.headerRui, "collected", Localize( "#COLLECTED_ITEMS", numOwnedItems, totalItems ) )
	}
}

#if UI
void function WhatsNewSetupItemButton( var button, ItemFlavor itemFlavor )
{
	Assert( !( button in file.activeItemButtons ) )

	file.activeItemButtons[button] <- itemFlavor

	Hud_AddEventHandler( button, UIE_CLICK, WhatsNewItemButton_OnClick )
	Hud_AddEventHandler( button, UIE_CLICKRIGHT, WhatsNewItemButton_OnRightOrDoubleClick )
	Hud_AddEventHandler( button, UIE_DOUBLECLICK, WhatsNewItemButton_OnRightOrDoubleClick )
}

void function WhatsNewRemoveItemButton( var button )
{
	Assert( button in file.activeItemButtons )

	delete file.activeItemButtons[button]

	Hud_RemoveEventHandler( button, UIE_CLICK, WhatsNewItemButton_OnClick )
	Hud_RemoveEventHandler( button, UIE_CLICKRIGHT, WhatsNewItemButton_OnRightOrDoubleClick )
	Hud_RemoveEventHandler( button, UIE_DOUBLECLICK, WhatsNewItemButton_OnRightOrDoubleClick )
}

void function WhatsNewItemButton_OnClick( var button )
{
	ItemFlavor flavor = file.activeItemButtons[button]
	UpdateActionContext( button )
	PlayPreviewSound( flavor )
	PreviewItem( flavor )
}

void function WhatsNewItemButton_OnRightOrDoubleClick( var button )
{
	CustomizeMenus_UpdateActionContext( button )
	ItemFlavor flavor = file.activeItemButtons[button]
	SetSelectedButton( button )
	UpdateActionContext( button )
	PreviewItem( flavor )
	AttemptToBuyItem( flavor )
}

void function SetSelectedButton( var selectedButton )
{
	foreach ( var button, ItemFlavor unused in file.activeItemButtons )
	{
		Hud_SetSelected( button, selectedButton == button )
	}
}

bool function WhatsNew_IsFocusedItem()
{
	foreach ( var button, ItemFlavor unused in file.activeItemButtons )
	{
		if ( Hud_IsFocused( button ) )
			return true
	}

	return false
}

bool function WhatsNew_IsFocusedItemLocked()
{
	if ( !GRX_IsInventoryReady() )
		return false

	foreach ( var button, ItemFlavor flavor in file.activeItemButtons )
	{
		if ( Hud_IsFocused( button ) )
			return !GRX_IsItemOwnedByPlayer( flavor )
	}

	return false
}

void function OnInputModeChanged( bool controllerModeActive )
{
	WhatsNewUpdateActionButton()
}

void function UpdateActionContext( var selectedButton )
{
	if ( selectedButton in file.activeItemButtons )
	{
		file.activeItem = file.activeItemButtons[selectedButton]
	}
	else
	{
		if ( IsControllerModeActive() )
		{
			foreach ( var button, ItemFlavor flavor in file.activeItemButtons )
			{
				if ( Hud_IsSelected( button ) )
				{
					file.activeItem = flavor
					break
				}
			}
		}
		else
		{
			file.activeItem = null
		}
	}

	WhatsNewUpdateActionButton()
}

void function WhatsNewBuyButton_OnClick( var button )
{
	if( file.activeItem == null )
	{
		Hud_SetVisible( file.actionButton, false )
		return
	}

	AttemptToBuyItem( expect ItemFlavor( file.activeItem ) )
}

void function WhatsNewUpdateActionButton()
{
	if ( file.isXButtonRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_X, WhatsNewBuyButton_OnClick )
		file.isXButtonRegistered = false
	}

	if ( file.actionButton == null )
		return

	if( file.activeItem == null )
	{
		Hud_SetVisible( file.actionButton, false )
		return
	}

	bool isOwned = GRX_IsItemOwnedByPlayer_AllowOutOfDateData( expect ItemFlavor( file.activeItem ) )

	Hud_SetVisible( file.actionButton, !isOwned )

	if ( isOwned )
		return

	bool controllerActive = IsControllerModeActive()

	HudElem_SetRuiArg( file.actionButton, "centerText", Localize( controllerActive ? "#X_BUTTON_BUY_PACK_CRAFT" : "#BUY_PACK_CRAFT", "" ) )

	if ( controllerActive && !file.isXButtonRegistered && !CustomizeMenus_IsFocusedItem() )
	{
		RegisterButtonPressedCallback( BUTTON_X, WhatsNewBuyButton_OnClick )
		file.isXButtonRegistered = true
	}
}

#if UI
void function WhatsNewSetActionButton( var button )
{
	if ( button != null )
		Assert( file.actionButton == null, "WhatsNewSetActionButton() passed a non-null value when file.actionButton wasn't null. This likely means some script isn't clearing it when it should." )

	if ( file.actionButton != null )
		Hud_RemoveEventHandler( file.actionButton, UIE_CLICK, WhatsNewBuyButton_OnClick )

	file.actionButton = button

	if ( file.actionButton != null )
		Hud_AddEventHandler( file.actionButton, UIE_CLICK, WhatsNewBuyButton_OnClick )

	WhatsNewUpdateActionButton()
}
#endif

void function AttemptToBuyItem( ItemFlavor flav )
{
	if( file.isUnlockOperationActive )
		return

	#if DEV
		if( !GRX_GetItemPurchasabilityInfo( flav ).isPurchasableAtAll )
			printt( flav._____INTERNAL_humanReadableRef, " Is not purchasable and the unlock buttom will not function with this item")
	#endif

	if ( ItemFlavor_GetGRXMode( flav ) != eItemFlavorGRXMode.NONE && !GRX_IsItemOwnedByPlayer( flav ) && GRX_GetItemPurchasabilityInfo( flav ).isPurchasableAtAll )
	{
		PurchaseDialogConfig pdc
		pdc.flav = flav
		pdc.quantity = 1
		pdc.markAsNew = false

		if( !GRX_IsOfferRestricted() )                           
		{
			pdc.purchaseOptionsMessage = "#COLLECTION_EVENT_UNLOCK_WITH"
			PurchaseDialogDeepLinkConfig pdlc
			pdlc.message = Localize( "#BUY_NAMED_PACK", file.associatedPackName )
			pdlc.priceText = file.itemSourceIcon
			pdlc.onPurchaseCallback = void function() : () {
				ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
				if ( activeThemedShopEvent != null )
				{
					JumpToSeasonTab( "ThemedShopPanel" )
					return
				}

				JumpToStoreTab()
			}
			pdc.deepLinkConfig = pdlc
		}

		pdc.onPurchaseStartCallback = void function() : () {
			file.isUnlockOperationActive = true
		}
		pdc.onPurchaseResultCallback = void function( bool unused ) : () {
			file.isUnlockOperationActive = false
		}
		PurchaseDialog( pdc )
		return
	}

	EmitUISound( "UI_Menu_Deny" )
	return
}

void function PlayPreviewSound( ItemFlavor item )
{
	string sound = "UI_Menu_Banner_Preview"

	int itemType = ItemFlavor_GetType( item )

	if ( itemType in previewSoundMap )
		sound = previewSoundMap[itemType]

	EmitUISound( sound )
}
#endif

void function PreviewItem( ItemFlavor flav )
{
	float scale = 1.0

	switch ( ItemFlavor_GetType( flav ) )
	{
		case eItemType.weapon_charm:
			scale = 1.5
			break

		case eItemType.weapon_skin:
			scale = 1.8
			break

		case eItemType.gladiator_card_frame:
			scale = 1.1
			break

		case eItemType.gladiator_card_intro_quip:
			scale = 1.08
			break

		case eItemType.gladiator_card_stance:
			scale = 1.0
			break
		case eItemType.character_skin:
			scale = 1.125
			break
	}
	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( flav ), -1, scale, true, null, true, "battlepass_center_ref" )
}

                                                           
void function SortWhatsNewList( array<ItemFlavor> whatsNewList )
{
	whatsNewList.sort( int function( ItemFlavor a, ItemFlavor b ) : () {

		int aQuality = ItemFlavor_HasQuality( a ) ? ItemFlavor_GetQuality( a ) : -1
		int bQuality = ItemFlavor_HasQuality( b ) ? ItemFlavor_GetQuality( b ) : -1
		if ( aQuality > bQuality )
			return -1
		else if ( aQuality < bQuality )
			return 1

		if ( ItemFlavor_GetType( a ) != ItemFlavor_GetType( b ) )
		{
			int diff = ItemFlavor_GetType( a ) - ItemFlavor_GetType( b )
			return diff / abs( diff )
		}

		return SortStringAlphabetize( Localize( ItemFlavor_GetLongName( a ) ), Localize( ItemFlavor_GetLongName( b ) ) )
	} )
}

int function FilterOwnedItems( array<ItemFlavor> whatsNewList )
{
	int owned = 0
	for ( int i = whatsNewList.len() - 1; i >= 0; i-- )
	{
		if( IsItemOwned( whatsNewList[i] ) )
		{
			owned++
			if( file.hideUnlocked )
				whatsNewList.remove( i )
		}
	}
	return owned
}

bool function IsItemOwned( ItemFlavor flavor )
{
	if( ItemFlavor_GetGRXMode( flavor ) == eItemFlavorGRXMode.REGULAR )
		return GRX_IsItemOwnedByPlayer( flavor )

	return true
}



