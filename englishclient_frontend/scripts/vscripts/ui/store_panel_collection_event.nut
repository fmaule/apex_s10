global function CollectionEventPanel_Init
global function StorePanelCollectionEvent_LevelInit
global function StorePanelCollectionEvent_LevelShutdown

struct {
	var panel
	var bigInfoBox
	var aboutButton
	var purchaseSinglePackButton
	var purchaseMultiplePacksButton
	var completionRewardBox
	                            
	var rewardBarPanel
	var rewardBarBacker
	var itemDetailsBox
	var openPackButton

	array<var>             allRewardButtons
	array<array<var> >     rewardButtonRows
	table<var, ItemFlavor> rewardButtonToRewardFlavMap

	ItemFlavor ornull activeCollectionEvent = null

	var WORKAROUND_currentlyFocusedRewardButtonForFooters = null
	int WORKAROUND_purchaseMultiplePacksButton_currentQty = -1
} file

const REWARD_BUTTONS_ROW_COUNT = 2
const REWARD_BUTTONS_COL_COUNT = 12

const PACK_BULK_PURCHASE_COUNT = 10

void function CollectionEventPanel_Init( var panel )
{
	file.panel = panel
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CollectionEventPanel_OnPanelShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CollectionEventPanel_OnPanelHide )

	file.bigInfoBox = Hud_GetChild( panel, "BigInfoBox" )
	file.aboutButton = Hud_GetChild( panel, "AboutButton" )
	file.purchaseSinglePackButton = Hud_GetChild( panel, "Purchase1PackButton" )
	file.purchaseMultiplePacksButton = Hud_GetChild( panel, "PurchaseNPacksButton" )
	file.completionRewardBox = Hud_GetChild( panel, "CompletionRewardBox" )
	                                                                               
	file.rewardBarPanel = Hud_GetChild( panel, "RewardBarPanel" )
	file.rewardBarBacker = Hud_GetChild( file.rewardBarPanel, "RewardBarBacker" )
	file.itemDetailsBox = Hud_GetChild( panel, "ItemDetailsBox" )
	file.openPackButton = Hud_GetChild( panel, "OpenPackButton" )

	for ( int rewardButtonRowIdx = 0; rewardButtonRowIdx < REWARD_BUTTONS_ROW_COUNT; rewardButtonRowIdx++ )
	{
		array<var> row = []
		for ( int rewardButtonColIdx = 0; rewardButtonColIdx < REWARD_BUTTONS_COL_COUNT; rewardButtonColIdx++ )
		{
			var rewardButton = Hud_GetChild( file.rewardBarPanel, format( "RewardButton%02dx%02d", rewardButtonColIdx + 1, rewardButtonRowIdx + 1 ) )
			Hud_Show( rewardButton )
			Hud_AddEventHandler( rewardButton, UIE_GET_FOCUS, RewardButton_OnGetFocus )
			Hud_AddEventHandler( rewardButton, UIE_LOSE_FOCUS, RewardButton_OnLoseFocus )
			Hud_AddEventHandler( rewardButton, UIE_CLICK, RewardButton_OnActivate )
			Hud_AddEventHandler( rewardButton, UIE_CLICKRIGHT, RewardButton_OnAltActivate )
			row.append( rewardButton )
			file.allRewardButtons.append( rewardButton )
		}
		file.rewardButtonRows.append( row )
	}

	Hud_AddEventHandler( file.aboutButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "CollectionEventAboutPage" ) ) )

	Hud_AddEventHandler( file.purchaseSinglePackButton, UIE_CLICK, void function( var button ) {
		PurchasePackButton_OnClick( button, 1 )
	} )
	Hud_AddEventHandler( file.purchaseMultiplePacksButton, UIE_CLICK, void function( var button ) {
		PurchasePackButton_OnClick( button, file.WORKAROUND_purchaseMultiplePacksButton_currentQty )
	} )

	                                                                                                      
	                                                                                                        
	                                                                                               

	Hud_AddEventHandler( file.completionRewardBox, UIE_GET_FOCUS, CompletionRewardBox_OnGetFocus )
	Hud_AddEventHandler( file.completionRewardBox, UIE_LOSE_FOCUS, CompletionRewardBox_OnLoseFocus )
	Hud_AddEventHandler( file.completionRewardBox, UIE_CLICK, CompletionRewardBox_OnClick )

	Hud_AddEventHandler( file.openPackButton, UIE_CLICK, OpenPackButton_OnClick )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT_BUY", "#A_BUTTON_INSPECT_BUY", null, IsFocusedItemInspectableAndBuyable )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", null, IsFocusedItemInspectableButNotBuyable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_PREVIEW_QUIPS", "", TryPreviewIncludedQuipForFocusedItem, ShouldShowIncludedQuipPreviewPromptFooter )
}

void function StorePanelCollectionEvent_LevelInit()
{
}

void function StorePanelCollectionEvent_LevelShutdown()
{
	file.WORKAROUND_currentlyFocusedRewardButtonForFooters = null
	file.rewardButtonToRewardFlavMap.clear()
}

void function CollectionEventPanel_OnPanelShow( var panel )
{
	UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )

	if ( GetCurrentPlaylistVarBool( "collection_event_panel_clear", true  ) )                                  
		file.rewardButtonToRewardFlavMap.clear()

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( CollectionEventPanel_UpdateGRXDependantElements )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( CollectionEventPanel_UpdateGRXDependantElements )

	if ( !GetCurrentPlaylistVarBool( "disableCollectionEventAutoAward", false ) )
		thread TryOpenLootCeremonyAndCompletionRewardPack()
}


void function CollectionEventPanel_OnPanelHide( var panel )
{
	file.activeCollectionEvent = null

	RunClientScript( "UIToClient_StopBattlePassScene" )

	RemoveCallback_OnGRXInventoryStateChanged( CollectionEventPanel_UpdateGRXDependantElements )
	RemoveCallback_OnGRXOffersRefreshed( CollectionEventPanel_UpdateGRXDependantElements )

	RunClientScript( "UIToClient_StopTempBattlePassPresentationBackground" )
}


void function CollectionEventPanel_UpdateGRXDependantElements()
{
	bool isInventoryReady                   = GRX_IsInventoryReady()
	bool offersReady                        = GRX_AreOffersReady()
	ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	bool haveActiveCollectionEvent          = (activeCollectionEvent != null)
	bool menuIsUsable                       = isInventoryReady && haveActiveCollectionEvent
	int currentMaxEventPackPurchaseCount    = 0

	file.activeCollectionEvent = activeCollectionEvent
	file.rewardButtonToRewardFlavMap.clear()

	if ( haveActiveCollectionEvent )
	{
		expect ItemFlavor( activeCollectionEvent )
		Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( activeCollectionEvent )

		array<CollectionEventRewardGroup> rewardGroups = CollectionEvent_GetRewardGroups( activeCollectionEvent )
		Assert( rewardGroups.len() == 2, format( "Only collection events with two reward groups are supported right now. (%s)", ItemFlavor_GetHumanReadableRef( activeCollectionEvent ) ) )

		HudElem_SetRuiArg( file.bigInfoBox, "title", ItemFlavor_GetShortName( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.bigInfoBox, "isOfferRestricted", GRX_IsOfferRestricted() )

		DisplayTime dt = SecondsToDHMS( maxint( 0, CalEvent_GetFinishUnixTime( activeCollectionEvent ) - GetUnixTimestamp() ) )
		HudElem_SetRuiArg( file.bigInfoBox, "timeRemainingText", Localize( "#DAYS_REMAINING", string( dt.days ), string( dt.hours ) ) )

		HudElem_SetRuiArg( file.bigInfoBox, "mainThemeCol", SrgbToLinear( CollectionEvent_GetMainThemeCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageBGTintCol", SrgbToLinear( CollectionEvent_GetFrontPageBGTintCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageTitleCol", SrgbToLinear( CollectionEvent_GetFrontPageTitleCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageSubtitleCol", SrgbToLinear( CollectionEvent_GetFrontPageSubtitleCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "frontPageTimeRemainingCol", SrgbToLinear( CollectionEvent_GetFrontPageTimeRemainingCol( activeCollectionEvent ) ) )
		HudElem_SetRuiArg( file.bigInfoBox, "bgPatternImage", CollectionEvent_GetBGPatternImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.bigInfoBox, "headerIcon", CollectionEvent_GetHeaderIcon( activeCollectionEvent ) )

		                                                                                    
		                                                                                               
		                                                                                          
		                                                                                                                                      

		HudElem_SetRuiArg( file.completionRewardBox, "bgPatternImage", CollectionEvent_GetBGTabPatternImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.completionRewardBox, "itemImage", CollectionEvent_GetHeirloomButtonImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.completionRewardBox, "itemsOwnedCount", CollectionEvent_GetItemCount( activeCollectionEvent, true, GetLocalClientPlayer() ) )
		HudElem_SetRuiArg( file.completionRewardBox, "totalItemsCount", CollectionEvent_GetItemCount( activeCollectionEvent, false, GetLocalClientPlayer() ) )
		HudElem_SetRuiArg( file.completionRewardBox, "headerText", CollectionEvent_GetHeirloomHeaderText( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.completionRewardBox, "unlockDesc", CollectionEvent_GetHeirloomUnlockDesc( activeCollectionEvent ) )

		HudElem_SetRuiArg( file.rewardBarBacker, "title", CollectionEvent_GetFrontPageRewardBoxTitle( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.rewardBarBacker, "bgPatternImage", CollectionEvent_GetBGTabPatternImage( activeCollectionEvent ) )
		HudElem_SetRuiArg( file.rewardBarBacker, "itemsOwnedNum", CollectionEvent_GetItemCount( activeCollectionEvent, true, GetLocalClientPlayer() ) )
		HudElem_SetRuiArg( file.rewardBarBacker, "totalItemsNum", CollectionEvent_GetItemCount( activeCollectionEvent, false, GetLocalClientPlayer() ) )

		foreach ( int rewardButtonRowIdx, array<var> rewardButtonRow in file.rewardButtonRows )
		{
			int rewardGroupIdx                     = rewardButtonRowIdx
			CollectionEventRewardGroup rewardGroup = rewardGroups[rewardButtonRowIdx]
			Assert( rewardGroup.rewards.len() <= rewardButtonRow.len(), format( "Collection event reward group has too many rewards. (%s)", ItemFlavor_GetHumanReadableRef( activeCollectionEvent ) ) )

			                                                                                                             
			                                                                                                                   
			                                                                                                           

			foreach ( int rewardButtonColIdx, var rewardButton in rewardButtonRow )
			{
				ItemFlavor rewardFlav = rewardGroup.rewards[rewardButtonColIdx]
				file.rewardButtonToRewardFlavMap[rewardButton] <- rewardFlav

				bool isOwned = isInventoryReady && GRX_IsItemOwnedByPlayer( rewardFlav )
				HudElem_SetRuiArg( rewardButton, "isOwned", isOwned )

				int quality = ItemFlavor_HasQuality( rewardFlav ) ? ItemFlavor_GetQuality( rewardFlav ) : 0
				Assert( quality == rewardGroup.quality, format( "Reward quality does not match collection event reward group quality. (%s, %s)", ItemFlavor_GetHumanReadableRef( activeCollectionEvent ), ItemFlavor_GetHumanReadableRef( rewardFlav ) ) )
				HudElem_SetRuiArg( rewardButton, "rarity", quality )
				RuiSetImage( Hud_GetRui( rewardButton ), "buttonImage", CustomizeMenu_GetRewardButtonImage( rewardFlav ) )
			}
		}

		if ( offersReady )
		{
			currentMaxEventPackPurchaseCount = CollectionEvent_GetCurrentMaxEventPackPurchaseCount( activeCollectionEvent, GetLocalClientPlayer() )

			                                                                                                               
			                                            
			   
			  	                                                  
			  	                                                       
			  	                                                                                 
			  	                                                                                                                     
			   
		}
	}

	if ( !menuIsUsable )
	{
		foreach ( var rewardButton in file.allRewardButtons )
			Hud_SetEnabled( rewardButton, false )
	}

	var focus = GetFocus()
	if ( !file.allRewardButtons.contains( GetFocus() ) && focus != file.completionRewardBox )
		focus = null
	UpdateFocusStuff( focus )

	Hud_SetVisible( file.purchaseSinglePackButton, !GRX_IsOfferRestricted() )
	Hud_SetLocked( file.purchaseSinglePackButton, currentMaxEventPackPurchaseCount < 1 )
	HudElem_SetRuiArg( file.purchaseSinglePackButton, "numPacks", 1 )
	int packBulkPurchaseCount = (currentMaxEventPackPurchaseCount < 2 ? PACK_BULK_PURCHASE_COUNT : ClampInt( currentMaxEventPackPurchaseCount, 2, PACK_BULK_PURCHASE_COUNT ))
	Hud_SetVisible( file.purchaseMultiplePacksButton, !GRX_IsOfferRestricted() )
	Hud_SetLocked( file.purchaseMultiplePacksButton, currentMaxEventPackPurchaseCount < packBulkPurchaseCount )
	HudElem_SetRuiArg( file.purchaseMultiplePacksButton, "numPacks", packBulkPurchaseCount )
	file.WORKAROUND_purchaseMultiplePacksButton_currentQty = packBulkPurchaseCount

	if ( isInventoryReady && GRX_IsOfferRestricted() )
		Hud_SetY( file.aboutButton, ContentScaledY( -500 ) )

	                                                       
	                    
	   
	  	                                                       
	  	                                
	  	 
	  		                                                                                                                           
	  		                                                     
	  		 
	  			                                             
	  			                                                                   
	  		 
	  		    
	  		 
	  			                                                                                                                                                              
	  		 
	  	 
	  	                                                                                                    
	   
	                                                                                         
}

                                   
string playingQuipEventName = ""
table<asset, int> nextQuipIdxMap = {}
   

void function UpdateFocusStuff( var focusedRewardButtonOrNull )
{
	                                   
	if ( playingQuipEventName != "" )
	{
		StopUISoundByName( playingQuipEventName )
		playingQuipEventName = ""
	}
	   

	file.WORKAROUND_currentlyFocusedRewardButtonForFooters = focusedRewardButtonOrNull

	ItemFlavor ornull activeCollectionEvent = file.activeCollectionEvent
	if ( activeCollectionEvent == null )
		return
	expect ItemFlavor(activeCollectionEvent)

	bool isCompletionReward = false

	ItemFlavor focusFlav
	if ( focusedRewardButtonOrNull == null || !GRX_IsInventoryReady() )
	{
		if ( !GRX_IsOfferRestricted() )
		{
			focusFlav = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
		}
		else
		{
			focusFlav = CollectionEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )
			isCompletionReward = true
		}
	}
	else if ( focusedRewardButtonOrNull in file.rewardButtonToRewardFlavMap )
	{
		focusFlav = file.rewardButtonToRewardFlavMap[focusedRewardButtonOrNull]
	}
	else if ( focusedRewardButtonOrNull == file.completionRewardBox )
	{
		focusFlav = CollectionEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )
		isCompletionReward = true
	}
	else
	{
		return
	}

	vector rarityCol
	string rarityText
	string nameText
	string descText
	bool showUnlockWithPack = false
	int premiumPrice        = -1
	int craftingPrice       = -1
	bool hasBonus           = false
	string bonusString      = ""

	bool isPack = (ItemFlavor_GetType( focusFlav ) == eItemType.account_pack)
	Hud_SetVisible( file.openPackButton, isPack )

	if ( isPack )
	{
		nameText = ItemFlavor_GetShortName( focusFlav )
		rarityCol = SrgbToLinear( CollectionEvent_GetMainThemeCol( activeCollectionEvent ) )
		rarityText = "#PACK"
		descText = "#COLLECTION_EVENT_PACK_DESCRIPTION"

		ItemFlavor completionRewardPack = CollectionEvent_GetCompletionRewardPack( activeCollectionEvent )
		UpdateLootBoxButton( file.openPackButton, [ focusFlav, completionRewardPack ] )
	}
	else if ( isCompletionReward )
	{
		rarityCol = SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, ItemFlavor_GetQuality( focusFlav ) + 1 ) / 255.0 )
		rarityText = ItemFlavor_GetQualityName( focusFlav )

		if ( CollectionEvent_AwardHeirloomShards( activeCollectionEvent ) )
		{
			nameText = Localize( "#N_HEIRLOOM_SHARDS", 150 )
		}
		else
		{
			nameText = ItemFlavor_GetLongName( focusFlav )
			descText = GetLocalizedItemFlavorDescriptionForOfferButton( focusFlav, false )
			descText += " - "
			descText += Localize( GRX_IsInventoryReady() ? (GRX_IsItemOwnedByPlayer( focusFlav ) ? "#OWNED" : "#LOCKED") : "" )
		}
	}
	else                   
	{
		nameText = ItemFlavor_GetLongName( focusFlav )
		rarityCol = SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, ItemFlavor_GetQuality( focusFlav ) + 1 ) / 255.0 )
		rarityText = ItemFlavor_GetQualityName( focusFlav )
		descText = GetLocalizedItemFlavorDescriptionForOfferButton( focusFlav, false )
		descText += " - "
		descText += Localize( GRX_IsInventoryReady() ? (GRX_IsItemOwnedByPlayer( focusFlav ) ? "#OWNED" : "#LOCKED") : "" )

		                                   
		int numQuips = GetIncludedQuips( focusFlav ).len()
		hasBonus = (numQuips > 0)
		bonusString = Localize( "#S03E02_BONUS_QUIPS_DESC", numQuips )
		TryPreviewIncludedQuip( focusFlav )
		                                   

		if ( !GRX_IsItemOwnedByPlayer( focusFlav ) )
		{
			if ( GRX_AreOffersReady() && GRX_IsInventoryReady() )
			{
				string offerLocation         = CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent )
				array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( focusFlav, offerLocation )
				if ( offers.len() > 0 )
				{
					Assert( offers.len() == 1 )
					GRXScriptOffer offer = offers[0]
					Assert( offer.prices.len() == 2 )
					foreach ( ItemFlavorBag price in offer.prices )
					{
						Assert( price.flavors.len() == 1, "No price given for ItemFlavor bag in GRX offer." )
						if ( price.flavors[0] == GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
						{
							Assert( premiumPrice == -1, "Inherited existing (NOT -1) Premium Currency price for ItemFlavor bag in GRX offer." )
							premiumPrice = price.quantities[0]
						}
						else if ( price.flavors[0] == GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
						{
							Assert( craftingPrice == -1, "Inherited existing (NOT -1) Crafting Materials price for ItemFlavor bag in GRX offer." )
							craftingPrice = price.quantities[0]
						}
						else
						{
							Assert( false, "Invalid currency - something that is *NOT* AC or CM - price for ItemFlavor bag in GRX offer." )
						}
					}
				}
			}

			if ( CollectionEvent_GetPackOffer( activeCollectionEvent ) != null )
				showUnlockWithPack = true
		}
	}

	if ( GRX_IsInventoryReady() && GRX_IsOfferRestricted()
			&& focusFlav == CollectionEvent_GetPrimaryCompletionRewardItem( activeCollectionEvent )
			&& GRX_GetPackCount( ItemFlavor_GetGRXIndex( CollectionEvent_GetCompletionRewardPack( activeCollectionEvent ) ) ) > 0 )
	{
		Hud_SetVisible( file.openPackButton, true )
		ItemFlavor completionRewardPack = CollectionEvent_GetCompletionRewardPack( activeCollectionEvent )
		UpdateLootBoxButton( file.openPackButton, [ completionRewardPack ] )
		isPack = true
	}

	RuiSetColorAlpha( Hud_GetRui( file.itemDetailsBox ), "rarityCol", rarityCol, 1.0 )
	HudElem_SetRuiArg( file.itemDetailsBox, "itemRarityText", rarityText )
	HudElem_SetRuiArg( file.itemDetailsBox, "itemNameText", nameText )
	HudElem_SetRuiArg( file.itemDetailsBox, "itemDescText", descText )
	HudElem_SetRuiArg( file.itemDetailsBox, "isPack", isPack )
	HudElem_SetRuiArg( file.itemDetailsBox, "showUnlockWithPack", showUnlockWithPack )
	HudElem_SetRuiArg( file.itemDetailsBox, "premiumPrice", premiumPrice )
	HudElem_SetRuiArg( file.itemDetailsBox, "craftingPrice", craftingPrice )
	HudElem_SetRuiArg( file.itemDetailsBox, "packName", CollectionEvent_GetMainPackShortPluralName( activeCollectionEvent ) )
	HudElem_SetRuiArg( file.itemDetailsBox, "packImage", CollectionEvent_GetMainPackImage( activeCollectionEvent ), eRuiArgType.IMAGE )

	                                   
	HudElem_SetRuiArg( file.itemDetailsBox, "hasBonus", hasBonus )
	HudElem_SetRuiArg( file.itemDetailsBox, "bonusString", bonusString )
	   

	bool shouldPlayAudioPreview = true

	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( focusFlav ), -1, 1.19, false, null, shouldPlayAudioPreview, "collection_event_ref" )
	UpdateFooterOptions()                             
}


                                   
array<asset> function GetIncludedQuips( ItemFlavor rewardFlav )
{
	asset rewardFlavAsset = ItemFlavor_GetAsset( rewardFlav )
	if ( !(rewardFlavAsset in S03E02_HARD_CODED_BONUS_QUIPS) )
		return []

	return S03E02_HARD_CODED_BONUS_QUIPS[rewardFlavAsset]
}
  
bool function ShouldShowIncludedQuipPreviewPromptFooter()
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return false
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	return GetIncludedQuips( focusFlav ).len() > 0
}
  
void function TryPreviewIncludedQuipForFocusedItem( var btn )
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	TryPreviewIncludedQuip( focusFlav )
}
  
void function TryPreviewIncludedQuip( ItemFlavor rewardFlav )
{
	if ( playingQuipEventName != "" )
	{
		StopUISoundByName( playingQuipEventName )
		playingQuipEventName = ""
	}

	array<asset> includedQuips = GetIncludedQuips( rewardFlav )
	if ( includedQuips.len() == 0 )
		return

	asset rewardFlavAsset = ItemFlavor_GetAsset( rewardFlav )
	if ( !(rewardFlavAsset in nextQuipIdxMap) )
		nextQuipIdxMap[rewardFlavAsset] <- RandomInt( includedQuips.len() )
	else
		nextQuipIdxMap[rewardFlavAsset] += 1

	ItemFlavor quipToPlay = GetItemFlavorByAsset( includedQuips[nextQuipIdxMap[rewardFlavAsset] % includedQuips.len()] )

	string quipAlias = ""
	if ( ItemFlavor_GetType( quipToPlay ) == eItemType.gladiator_card_intro_quip )
	{
		quipAlias = CharacterIntroQuip_GetVoiceSoundEvent( quipToPlay )
	}
	else if ( ItemFlavor_GetType( quipToPlay ) == eItemType.gladiator_card_kill_quip )
	{
		quipAlias = CharacterKillQuip_GetVictimVoiceSoundEvent( quipToPlay )
	}

	if ( quipAlias != "" )
	{
		EmitUISound( quipAlias )
		playingQuipEventName = quipAlias
	}
}
                                   


void function RewardButton_OnGetFocus( var btn )
{
	UpdateFocusStuff( btn )
}


void function RewardButton_OnLoseFocus( var btn )
{
	UpdateFocusStuff( null )
}


void function RewardButton_OnActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	ItemFlavor rewardFlav = file.rewardButtonToRewardFlavMap[btn]
	if ( !IsItemFlavorInspectable( rewardFlav ) )
		return

	if ( !GRX_AreOffersReady() )
		return

	ItemFlavor activeCollectionEvent = expect ItemFlavor( file.activeCollectionEvent )
	string offerLocation             = CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent )
	array<GRXScriptOffer> offers     = GRX_GetItemDedicatedStoreOffers( rewardFlav, offerLocation )

	if ( offers.len() > 0 )
		StoreInspectMenu_AttemptOpenWithOffer( offers[0] )
}


void function RewardButton_OnAltActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	ItemFlavor rewardFlav = file.rewardButtonToRewardFlavMap[btn]
	if ( !IsItemFlavorEquippable( rewardFlav ) )
		return

	EmitUISound( "UI_Menu_Equip_Generic" )
	EquipItemFlavorInAppropriateLoadoutSlot( rewardFlav )
}


bool function CheckInspectableBuyable( ItemFlavor flav, bool wantBuyable )
{
	if ( !IsItemFlavorInspectable( flav ) )
		return false

	if ( file.activeCollectionEvent == null )
		return false

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return !wantBuyable

	if ( GRX_IsItemOwnedByPlayer( flav ) )
		return !wantBuyable

	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	string offerLocation             = CollectionEvent_GetFrontPageGRXOfferLocation( activeCollectionEvent )
	array<GRXScriptOffer> offers     = GRX_GetItemDedicatedStoreOffers( flav, offerLocation )
	if ( offers.len() == 0 )
		return !wantBuyable

	return wantBuyable
}


bool function IsFocusedItemInspectableButNotBuyable()
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return false
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	return CheckInspectableBuyable( focusFlav, false )
}


bool function IsFocusedItemInspectableAndBuyable()
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return false
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	return CheckInspectableBuyable( focusFlav, true )
}


bool function IsFocusedItemEquippable()
{
	var focus = file.WORKAROUND_currentlyFocusedRewardButtonForFooters                                                                            
	if ( !(focus in file.rewardButtonToRewardFlavMap) )
		return false
	ItemFlavor focusFlav = file.rewardButtonToRewardFlavMap[focus]

	if ( !IsItemFlavorEquippable( focusFlav ) )
		return false

	return true
}


void function PurchasePackButton_OnClick( var btn, int count )
{
	if ( Hud_IsLocked( btn ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	                                                                                                   
	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	ItemFlavor packFlav              = CollectionEvent_GetMainPackFlav( activeCollectionEvent )

	PurchaseDialogConfig pdc
	pdc.flav = packFlav
	pdc.quantity = count
	pdc.markAsNew = false
	PurchaseDialog( pdc )
}


                                                            
   
  	                       
   
  
  
                                                             
   
  	                        
   


void function CompletionRewardBox_OnGetFocus( var btn )
{
	UpdateFocusStuff( btn )
}


void function CompletionRewardBox_OnLoseFocus( var btn )
{
	UpdateFocusStuff( null )
}


void function CompletionRewardBox_OnClick( var btn )
{
	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	if ( CollectionEvent_AwardHeirloomShards( activeCollectionEvent ) )
	{
		JumpToHeirloomShop()                                              
		return
	}

	                                                                                                             
	ItemFlavor completionRewardPack = CollectionEvent_GetCompletionRewardPack( activeCollectionEvent )
	array<ItemFlavor> packContents = GRXPack_GetPackContents( completionRewardPack )

	                                                                                            
	GRXScriptOffer fakeOffer
	fakeOffer.titleText = ItemFlavor_GetLongName( completionRewardPack )
	fakeOffer.descText = ""
	fakeOffer.prereq = activeCollectionEvent

	ItemFlavorBag priceBag
	priceBag.flavors.append( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
	priceBag.quantities.append( 999999999 )
	fakeOffer.prices.append( priceBag )

	foreach ( item in packContents )
		AddItemToFakeOffer( fakeOffer, item )

	StoreInspectMenu_AttemptOpenWithOffer( fakeOffer )
}


                                                         
   
  	                          
  	 
  		                          
  		      
  	 
  
  	                                                                                                               
  	                                                                                
  	                                                                                                       
  	                                                                                                                      
  		                    
  		 
  			                                                    
  				              
  				 
  					                                
  					                              
  					 
  						           
  					 
  					                                                            
  					 
  						           
  					 
  					                                                     
  					 
  						                                                          
  						     
  					 
  					    
  					 
  						              
  					 
  				 
  			    
  		 
  	   
   

void function TryOpenLootCeremonyAndCompletionRewardPack()
{
	WaitFrame()

	bool grxReady = GRX_IsInventoryReady() && GRX_AreOffersReady()
	if ( !grxReady )
		return

	if ( file.activeCollectionEvent == null )
		return

	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	ItemFlavor completionRewardPack  = CollectionEvent_GetCompletionRewardPack( activeCollectionEvent )
	if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( completionRewardPack ) ) > 0 )
		OnLobbyOpenLootBoxMenu_ButtonPress( completionRewardPack )
}

void function OpenPackButton_OnClick( var btn )
{
	if ( Hud_IsLocked( btn ) )
		return

	ItemFlavor activeCollectionEvent = expect ItemFlavor(file.activeCollectionEvent)
	ItemFlavor packFlav              = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
	if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( packFlav ) ) > 0 )
		OnLobbyOpenLootBoxMenu_ButtonPress( packFlav )

	ItemFlavor completionRewardPack = CollectionEvent_GetCompletionRewardPack( activeCollectionEvent )
	if ( GRX_GetPackCount( ItemFlavor_GetGRXIndex( completionRewardPack ) ) > 0 )
		OnLobbyOpenLootBoxMenu_ButtonPress( completionRewardPack )
}


