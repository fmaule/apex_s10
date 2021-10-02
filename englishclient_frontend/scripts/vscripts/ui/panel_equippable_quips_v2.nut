global function InitQuipsPanel
global function InitEmotesPanel
global function QuipPanel_SetItemTypeFilter
global function QuipsPanel_Update

struct
{
	table<var,var>              listPanel
	table<var,bool>             isBoxPanel
	array<ItemFlavor> 			quipList
	string 						lastSoundPlayed
	array<int>					filterTypes
} file

void function InitEmotesPanel( var panel )
{
	___Init( panel )
	file.isBoxPanel[ panel ] <- true
}

void function InitQuipsPanel( var panel )
{
	___Init( panel )
	file.isBoxPanel[ panel ] <- false
}

void function ___Init( var panel )
{
	file.listPanel[ panel ] <- Hud_GetChild( panel, "QuipList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, QuipsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, QuipsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, QuipsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )


	var gridPanel = file.listPanel[ panel ]
	void functionref( var ) func = (
			void function( var button ) : ( gridPanel )
			{
				SetOrClearFavoredQuipFromFocus( gridPanel )
			}
	)
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemAbleToBeFavored )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemAlreadyFavored )
}


void function QuipsPanel_OnShow( var panel )
{
	if ( file.filterTypes.contains( eItemType.character_emote ) )
		UI_SetPresentationType( ePresentationType.CHARACTER_QUIPS )
	else
		UI_SetPresentationType( ePresentationType.HOLOSPRAYS )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, QuipsPanel_Update )
	QuipsPanel_Update( panel )
}


void function QuipsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, QuipsPanel_Update )
	QuipsPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel[ panel ], "ScrollPanel" )
	if ( file.quipList.len() > 0 )
	{
		Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
		foreach ( int flavIdx, ItemFlavor flav in file.quipList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			Hud_ClearToolTipData( button )
		}
	}

}


void function QuipsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel[ panel ], "ScrollPanel" )

	string hintSub = ""
	bool useDetailed = false
	int rows = 4
	int columns = 1
	if ( file.filterTypes.contains( eItemType.character_emote ) )
	{
		UI_SetPresentationType( ePresentationType.CHARACTER_QUIPS )
		hintSub = "#HINT_SOCIAL_ANTI_PEEK"
		useDetailed = true
		columns = 2
	}
	else if ( file.filterTypes.contains( eItemType.emote_icon ) )
	{
		UI_SetPresentationType( ePresentationType.HOLOSPRAYS )
		useDetailed = true
		columns = 3
	}
	else
	{
		UI_SetPresentationType( ePresentationType.HOLOSPRAYS )
		hintSub = "#HINT_SOCIAL_QUIPS_ENEMIES"
	}
	CharacterEmotesPanel_SetHintSub( hintSub )

	          
	foreach ( int flavIdx, ItemFlavor unused in file.quipList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.quipList.clear()

	StopLastPlayedQuip()

	                                  
	if ( IsPanelActive( panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()

		array<LoadoutEntry> entries
		LoadoutEntry entry
		for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
		{
			entry   = Loadout_CharacterQuip( character, i )
			entries.append( entry )
		}

		file.quipList = clone GetLoadoutItemsSortedForMenu( entry, ( int function( ItemFlavor a ) : () { return 0 } ) )
		SortQuipsAndFilter( character, file.quipList )

		array<LoadoutEntry> auxEntries
		for ( int i=0; i<MAX_FAVORED_QUIPS; i++ )
		{
			auxEntries.append( Loadout_FavoredQuip( character, i ) )
		}

		if ( !useDetailed )
			Hud_InitGridButtons( file.listPanel[ panel ], file.quipList.len() )
		else
			
		#if NX_PROG || PC_PROG_NX_UI
			if ( !IsNxHandheldMode() )
			{
				Hud_InitGridButtonsDetailed( file.listPanel[ panel ], file.quipList.len(), rows, columns )
			}
			else
			{
				Hud_InitGridButtonsDetailed( file.listPanel[ panel ], file.quipList.len(), 3, columns )
			}
		#else
			Hud_InitGridButtonsDetailed( file.listPanel[ panel ], file.quipList.len(), rows, columns )
		#endif
			
		bool emptyShown = false
		foreach ( int flavIdx, ItemFlavor flav in file.quipList )
		{
			int type = ItemFlavor_GetType( flav )
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewQuip, CanEquipCanBuyCharacterItemCheck, false, null, null, auxEntries, CustomizeButton_AddOrClearFavoredQuip )

			Hud_ClearToolTipData( button )
			if ( file.isBoxPanel[ panel ] )
			{
				var rui = Hud_GetRui( button )
				                                           
				RuiDestroyNestedIfAlive( rui, "badge" )

				RuiSetBool( rui, "displayQuality", true )

				var nestedRui = CreateNestedRuiForQuip( rui, "badge", LocalClientEHI(), flav, character )

				if ( type == eItemType.gladiator_card_intro_quip || type == eItemType.gladiator_card_kill_quip )
				{
					RuiSetFloat( nestedRui, "fontSize", 28.0 )
					RuiSetFloat( nestedRui, "centerLineBreakWidth", 100.0 )
				}

				ToolTipData toolTipData
				toolTipData.titleText = Localize( ItemFlavor_GetLongName( flav ) )
				toolTipData.descText = Localize( ItemFlavor_GetTypeName( flav ) )
				toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN
				Hud_SetToolTipData( button, toolTipData )
			}
		}
		Hud_ScrollToTop( file.listPanel[ panel ] )
	}
}


void function QuipsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewQuip( ItemFlavor flav )
{
	StopLastPlayedQuip()

	if ( CharacterQuip_IsTheEmpty( flav ) )
		return

	int type = ItemFlavor_GetType( flav )
	string ref = "customize_character_skin_ref"
	bool showLow = false
	float scale = 1.0
	switch ( type )
	{
                
		case eItemType.character_emote:
			showLow = true
			break
        
		case eItemType.gladiator_card_intro_quip:
		case eItemType.gladiator_card_kill_quip:
			ref = "customize_character_emote_quip_ref"
			break

		case eItemType.emote_icon:
			ref = "customize_character_emotes_ref"
			scale = 0.6
			break
	}

	switch ( type )
	{
              
		case eItemType.character_emote:
			ItemFlavor ornull character = CharacterQuip_GetCharacterFlavor( flav )
			int chIndex = -1
			if ( character != null )
			{
				expect ItemFlavor( character )
				chIndex = ItemFlavor_GetNetworkIndex_DEPRECATED( character )
			}
			RunClientScript( "UIToClient_PreviewCharacterEmote", ItemFlavor_GetGUID( flav ), chIndex )
			break
      
		default:


			bool isNxHH = false
#if NX_PROG || PC_PROG_NX_UI
			isNxHH = IsNxHandheldMode()
#endif
			RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( flav ), -1, scale, showLow, null, false, ref, isNxHH )
			break
	}

	string subAlias = CharacterQuip_GetAliasSubName( flav )

	if ( subAlias != "" )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		asset playerSettings = CharacterClass_GetSetFile( character )
		string voice = GetGlobalSettingsString( playerSettings, "voice" )

		string quipAlias = "diag_mp_" + voice + "_" + subAlias + "_1p"
		if ( quipAlias != "" )
		{
			EmitUISound( quipAlias )
			file.lastSoundPlayed = quipAlias
		}
	}

}


void function StopLastPlayedQuip()
{
	if ( file.lastSoundPlayed != "" )
		StopUISoundByName( file.lastSoundPlayed )
}


void function SortQuipsAndFilter( ItemFlavor character, array<ItemFlavor> emoteList )
{
	table<ItemFlavor, int> equippedQuipSet
	for ( int i = 0; i < MAX_QUIPS_EQUIPPED; i++ )
	{
		LoadoutEntry emoteSlot = Loadout_CharacterQuip( character, i )
		if ( LoadoutSlot_IsReady( LocalClientEHI(), emoteSlot ) )
		{
			ItemFlavor quip = LoadoutSlot_GetItemFlavor( LocalClientEHI(), emoteSlot )
			equippedQuipSet[quip] <- i
		}
	}

	bool emptyShown = false
	ItemFlavor firstEmpty

	for ( int i = emoteList.len() - 1; i >= 0; i-- )
	{
		if ( file.filterTypes.len() > 0 )
		{
			int type = ItemFlavor_GetType( emoteList[i] )
			if ( !file.filterTypes.contains(type) )
			{
				emoteList.remove( i )
				continue
			}
		}

		bool isEmpty = CharacterQuip_IsTheEmpty( emoteList[i] )

		if ( isEmpty )
		{
			firstEmpty = emoteList[i]
			emptyShown = true
		}

		if ( isEmpty )
			emoteList.remove( i )
	}

	emoteList.sort( int function( ItemFlavor a, ItemFlavor b ) : ( equippedQuipSet ) {
		bool a_isEquipped = (a in equippedQuipSet)
		bool b_isEquipped = (b in equippedQuipSet)
		if ( a_isEquipped != b_isEquipped )
			return (a_isEquipped ? -1 : 1)

		if ( ItemFlavor_GetType( a ) != ItemFlavor_GetType( b ) )
		{
			int diff = ItemFlavor_GetType( a ) - ItemFlavor_GetType( b )
			return diff / abs( diff )
		}
		else
		{
			int itemType = ItemFlavor_GetType( a )

			int aQuality = ItemFlavor_HasQuality( a ) ? ItemFlavor_GetQuality( a ) : -1
			int bQuality = ItemFlavor_HasQuality( b ) ? ItemFlavor_GetQuality( b ) : -1
			if ( aQuality > bQuality )
				return -1
			else if ( aQuality < bQuality )
				return 1

			return SortStringAlphabetize( Localize( ItemFlavor_GetLongName( a ) ), Localize( ItemFlavor_GetLongName( b ) ) )
		}
		unreachable
	} )
}


bool function ShouldDisplayQuip( ItemFlavor quip, table<ItemFlavor, int> equippedQuipSet, int quipIndex, ItemFlavor character )
{
	if ( CharacterQuip_IsTheEmpty( quip ) )
		return true

	LoadoutEntry emoteSlot = Loadout_CharacterQuip( character, quipIndex )
	if ( LoadoutSlot_IsReady( LocalClientEHI(), emoteSlot ) )
	{
		ItemFlavor equippedQuip = LoadoutSlot_GetItemFlavor( LocalClientEHI(), emoteSlot )
		if ( equippedQuip == quip )
			return true
		if ( quip in equippedQuipSet )
			return false
	}

	return true
}

void function QuipPanel_SetItemTypeFilter( array<int> filters )
{
	file.filterTypes = filters
}
