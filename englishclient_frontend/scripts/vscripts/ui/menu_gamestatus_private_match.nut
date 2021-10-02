global function InitPrivateMatchGameStatusMenu

#if UI
global function EnablePrivateMatchGameStatusMenu
global function IsPrivateMatchGameStatusMenuOpen
global function TogglePrivateMatchGameStatusMenu
global function OpenPrivateMatchGameStatusMenu
global function ClosePrivateMatchGameStatusMenu
global function SetChatModeButtonText
global function SetSpecatorChatModeState
global function SetChatTargetText
global function InitPrivateMatchRosterPanel
global function InitPrivateMatchOverviewPanel
global function InitPrivateMatchAdminPanel
#endif

#if CLIENT
global function ServerCallback_PrivateMatch_PopulateGameStatusMenu
global function ServerCallback_PrivateMatch_OnEntityKilled
global function PrivateMatch_PopulateGameStatusMenu
global function PrivateMatch_GameStatus_GetPlayerButton
global function PrivateMatch_GameStatus_ConfigurePlayerButton
global function PrivateMatch_UpdateChatTarget
global function PrivateMatch_ToggleUpdatePlayerConnections
global function ClientCodeCallback_SpectatorGetOrderedTarget
#endif


const int TEAM_COUNT_PANEL_ONE = 3
const int TEAM_COUNT_PANEL_TWO = 8
const int TEAM_COUNT_PANEL_THREE = 7

enum ePlayerHealthStatus
{
	PM_PLAYERSTATE_ALIVE,
	PM_PLAYERSTATE_BLEEDOUT,
	PM_PLAYERSTATE_DEAD,
	PM_PLAYERSTATE_REVIVING,
	PM_PLAYERSTATE_ELIMINATED,

	_count
}

struct TeamRosterStruct
{
	var           headerPanel
	var           listPanel
	int           teamIndex
	int			  teamPlacement
	int           teamSize
	int           teamDisplayNumber

	array<var>      _listButtons

	table< var, entity > buttonPlayerMap
}

struct TeamDeatailsData
{
	int teamIndex
	int teamValue
	int teamKills
	int playerAlive
	string teamName
}

struct ButtonData
{
	asset characterPortrait
	int killCount
	string playerName
}

struct
{
	var menu

	var decorationRui
	var menuHeaderRui

	var teamRosterPanel
	var overviewPanel
	var adminPanel

	var teamOverviewOne
	var teamOverviewTwo

	var textChat
	var chatInputLine
	var chatButtonIcon

	var endMatchButton
	var chatModeButton
	var chatSpectCheckBox
	var chatTargetText

	bool enableMenu = false
	bool disableNavigateBack = false

	table< int, TeamRosterStruct > teamRosters
	var teamOneLargePanel
	var teamTwoLargePanel
	int lastPlayerCount = 0
	array< var > teamOverviewPanels
	array< entity > playersToAdd
	table< int, array< entity > > teamPlayersMap
	table< int, array< entity > > unorderedTeamPlayersMap
	table< int, array< ButtonData > > teamButtonMap

	bool isInitialized = false
	bool tabsInitialized = false
	bool updateConnections = false

	bool inputsRegistered = false

} file

void function InitPrivateMatchGameStatusMenu( var menu )
{
	file.menu = menu
	file.teamRosterPanel = Hud_GetChild( menu, "PrivateMatchRosterPanel" )
	file.overviewPanel = Hud_GetChild( menu, "PrivateMatchOverviewPanel" )
	file.adminPanel = Hud_GetChild( menu, "PrivateMatchAdminPanel" )

	#if UI
		file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
		RuiSetString( file.menuHeaderRui, "menuName", "#TOURNAMENT_MATCH_STATUS" )

		AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenPrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnShowPrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnHidePrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClosePrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

		AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
		AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", ClosePrivateMatchGameStatusMenu, CanNavigateBack )

		AddCommandForMenuToPassThrough( menu, "toggle_inventory" )
		
		AddUICallback_OnLevelInit( void function() : ( menu )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchGameStatusMenu", menu )
		} )
		
		HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgColor", <0, 0, 1>, eRuiArgType.VECTOR )
		HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgAlpha", 1.6, eRuiArgType.FLOAT )

		SetTabRightSound( menu, "UI_InGame_InventoryTab_Select" )
		SetTabLeftSound( menu, "UI_InGame_InventoryTab_Select" )

		file.isInitialized = true
	#elseif CLIENT


		int maxTeams = PrivateMatch_GetMaxTeamsForSelectedGamemode()
		for ( int index; index < maxTeams; index++ )
		{
			string team          = "Team"
			string indexName     = index < 10 ? "0" + string( index ) : string( index )
			string teamIndexName = team + indexName
			var teamPanel = Hud_GetChild( file.teamRosterPanel, teamIndexName )

			file.teamRosters[TEAM_MULTITEAM_FIRST + index] <- CreateTeamPlacement( TEAM_MULTITEAM_FIRST + index, 3, teamPanel )
		}

		if ( IsPrivateMatch() || IsPrivateMatchLobby() )
		{
			                                                                                                 
			file.teamOneLargePanel = Hud_GetRui( Hud_GetChild( file.overviewPanel, "TeamOverviewLarge1" ) )
			RuiSetInt( file.teamOneLargePanel, "teamPosition", 1 )
			file.teamTwoLargePanel = Hud_GetRui( Hud_GetChild( file.overviewPanel, "TeamOverviewLarge2" ) )
			RuiSetInt( file.teamTwoLargePanel, "teamPosition", 2 )

			file.teamOverviewPanels.clear()
			SetupOverviewPanel( 1, TEAM_COUNT_PANEL_ONE )
			SetupOverviewPanel( 2, TEAM_COUNT_PANEL_TWO )
			SetupOverviewPanel( 3, TEAM_COUNT_PANEL_THREE )

			                                                                            
			if(GetGameState() >= eGameState.Playing)
			{
				RunUIScript( "EnablePrivateMatchGameStatusMenu", file.enableMenu )
			}

			if ( !file.isInitialized )
			{
				AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

				                                                 
				AddCallback_GameStateEnter( eGameState.Playing, OnGameStateEnter_Playing )
				SwitchChatModeButtonText( GetGlobalNetInt( "adminChatMode" ) )

				file.isInitialized = true
			}
		}
	#endif
}

#if UI
void function InitPrivateMatchRosterPanel( var panel )
{
}

void function RegisterInputs()
{
	if( file.inputsRegistered )
		return

	#if PC_PROG
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, FocusChat_OnActivate )
	#else
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, EnterText_OnActivate )
	#endif

	file.inputsRegistered = true
}

void function DeRegisterInputs()
{
	if ( !file.inputsRegistered )
		return

	#if PC_PROG
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, FocusChat_OnActivate )
	#else
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, EnterText_OnActivate )
	#endif

	file.inputsRegistered = false
}

void function FocusChat_OnActivate( var button )
{
	Hud_SetFocused( file.chatInputLine )
}

void function EnterText_OnActivate( var button )
{
	if ( !HudChat_HasAnyMessageModeStoppedRecently() && Hud_IsVisible( file.textChat ) )
		Hud_StartMessageMode( file.textChat )
}

void function EndMatchButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	ConfirmDialogData data
	data.headerText = "#TOURNAMENT_END_MATCH_DIALOG_HEADER"
	data.messageText = "#TOURNAMENT_END_MATCH_DIALOG_MSG" 
	data.resultCallback = void function( int dialogResult ) 
	{
		if ( dialogResult == eDialogResult.YES )
		{
			ClosePrivateMatchGameStatusMenu( null )
			if ( HasMatchAdminRole() )
			{
				Remote_ServerCallFunction( "ClientCallback_PrivateMatchEndMatchEarly" )
			}
		}
	}

	OpenConfirmDialogFromData( data )
}

void function InitPrivateMatchOverviewPanel( var panel )
{
	var teamOneHeaderRui = Hud_GetRui( Hud_GetChild( panel, "TeamOverviewHeader01" ) )
	RuiSetString( teamOneHeaderRui, "kills", Localize( "#TOURNAMENT_SPECTATOR_TEAM_KILLS" ) )
	RuiSetString( teamOneHeaderRui, "teamName", Localize( "#TOURNAMENT_SPECTATOR_TEAM_NAME" ) )
	RuiSetString( teamOneHeaderRui, "playersAlive", Localize( "#TOURNAMENT_SPECTATOR_PLAYERS_ALIVE" ) )
}

void function InitPrivateMatchAdminPanel( var panel )
{
	AddUICallback_InputModeChanged( ControllerIconVisibilty )

	file.endMatchButton = Hud_GetChild( panel, "EndMatchButton" )
	HudElem_SetRuiArg( file.endMatchButton, "buttonText", Localize( "#TOURNAMENT_END_MATCH" ) )
	Hud_AddEventHandler( file.endMatchButton, UIE_CLICK, EndMatchButton_OnActivate )

	file.textChat = Hud_GetChild( panel, "AdminChatWindow" )
	file.chatInputLine = Hud_GetChild( file.textChat, "ChatInputLine" )

	file.chatButtonIcon = Hud_GetChild( panel, "AdminChatBoxIcon")

	file.chatModeButton = Hud_GetChild( panel, "AdminChatModeButton" )
	Hud_AddEventHandler( file.chatModeButton, UIE_CLICK, ChatModeButton_OnActivate )

	file.chatSpectCheckBox = Hud_GetChild( panel, "SpectatorChatCheckBox" )
	Hud_AddEventHandler( file.chatSpectCheckBox, UIE_CLICK, ChatSpectatorCheckBox_OnActivate )

	file.chatTargetText = Hud_GetChild( panel, "AdminChatTarget" )
}

void function SetChatModeButtonText( string newText )
{
	ToolTipData adminChatModeTooltip
	adminChatModeTooltip.descText = newText
	HudElem_SetRuiArg( file.chatModeButton, "buttonText", newText )
}


void function SetSpecatorChatModeState( bool isActive, bool isSelected )
{
	HudElem_SetRuiArg( file.chatSpectCheckBox, "isActive", isActive )

	HudElem_SetRuiArg( file.chatSpectCheckBox, "isSelected", isSelected )
}

void function SetChatTargetText( string target )
{
	if ( target != "" )
	{
		HudElem_SetRuiArg( file.chatTargetText, "targetText", Localize("#TOURNAMENT_SPECTATOR_CHAT_TARGET" ) + target )
	}
	else
	{
		HudElem_SetRuiArg( file.chatTargetText, "targetText", "" )
	}
}

void function ControllerIconVisibilty( bool controllerModeActive )
{
	Hud_SetEnabled( file.chatButtonIcon, controllerModeActive )
	Hud_SetVisible( file.chatButtonIcon, controllerModeActive )
}

#endif

#if CLIENT

int function ClientCodeCallback_SpectatorGetOrderedTarget( int targetIndex, int team )
{
	PopulateOrderedTeamMap()

	array< int > newIndex = [ -1, -1, -1 ]

	if ( team in file.unorderedTeamPlayersMap )
	{
		int index = 0
		foreach ( playerIndex, player in file.unorderedTeamPlayersMap[team] )
		{
			if ( IsValid( player ) )
				newIndex[file.teamPlayersMap[team].find( player )] = player.GetTeamMemberIndex() - index
			else
				index++
		}
		return newIndex[targetIndex]
	}

	return -1
}

void function SwitchChatModeButtonText( int chatMode )
{
	string chatModeText = ""
	switch ( chatMode )
	{
		case ACM_PLAYER:
		{
			chatModeText = Localize( "#TOURNAMENT_PLAYER_CHAT" ) 
		}
		break
		case ACM_TEAM:
		{
			chatModeText = Localize( "#TOURNAMENT_TEAM_CHAT" ) 
		}
		break
		case ACM_SPECTATORS:
		{
			chatModeText = Localize( "#TOURNAMENT_SPECTATOR_CHAT" ) 
		}
		break
		case ACM_ALL_PLAYERS:
		{
			chatModeText = Localize( "#TOURNAMENT_ALL_CHAT" ) 
		}
		break
	}

	RunUIScript( "SetChatModeButtonText", chatModeText )
}

void function SetupOverviewPanel( int panelNum, int panelSize )
{
	var teamOverview = Hud_GetChild( file.overviewPanel, "TeamOverview0" + panelNum )
	Hud_InitGridButtons( teamOverview, panelSize )
	var scrollPanel = Hud_GetChild( teamOverview, "ScrollPanel" )

	for ( int i = 0; i < panelSize; i++ )
	{
		var panel = Hud_GetRui( Hud_GetChild( scrollPanel, ("GridButton" + i) ) )
		RuiSetInt( panel, "teamPosition", file.teamOverviewPanels.len() + 3 )
		file.teamOverviewPanels.insert( file.teamOverviewPanels.len(), panel )
	}
}

TeamRosterStruct function CreateTeamPlacement( int teamIndex, int teamSize, var panel )
{
	TeamRosterStruct teamPlacement
	teamPlacement.teamIndex = teamIndex
	teamPlacement.teamDisplayNumber = teamIndex - 1
	teamPlacement.teamSize = teamSize

	teamPlacement.headerPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_HEADER_PANEL )
	teamPlacement.listPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_BUTTON_PANEL )

	return teamPlacement
}

void function ServerCallback_PrivateMatch_OnEntityKilled( entity attacker, entity victim )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() )
		return

	if ( !IsValid( attacker ) || !attacker.IsPlayer() )
		return

	int teamIndex = attacker.GetTeam()

	if ( teamIndex in file.teamButtonMap )
	{
		for ( int playerIndex = 0; playerIndex < file.teamButtonMap[teamIndex].len(); playerIndex++ )
		{
			if ( file.teamButtonMap[teamIndex][playerIndex].playerName == attacker.GetPlayerNameWithClanTag() )
			{
				file.teamButtonMap[teamIndex][playerIndex].killCount++
				break
			}
		}
	}
}

int function PrivateMatch_SortButtonDataByName( ButtonData a, ButtonData b )
{
	if ( a.playerName > b.playerName )
		return 1

	if ( a.playerName < b.playerName )
		return -1

	return 0
}

void function UpdateButtonData( entity player, int teamIndex )
{
	ButtonData buttonData
	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	buttonData.characterPortrait = CharacterClass_GetGalleryPortrait( character )
	buttonData.killCount = player.GetPlayerNetInt( "kills" )
	buttonData.playerName = player.GetPlayerNameWithClanTag()
	file.teamButtonMap[teamIndex].append( buttonData )
}

void function ServerCallback_PrivateMatch_PopulateGameStatusMenu()
{
	array<entity> players = GetPlayerArray()

	foreach ( player in players )
	{
		if ( !IsValid( player ) )
			continue

		bool inTeam = false
		int teamIndex = player.GetTeam()

		if ( !(teamIndex in file.teamButtonMap) )
			file.teamButtonMap[teamIndex] <- []

		if ( file.teamButtonMap[teamIndex].len() != 0 )
		{
			foreach ( buttonData in file.teamButtonMap[teamIndex] )
			{
				if ( buttonData.playerName == player.GetPlayerNameWithClanTag() )
				{
					inTeam = true
					break
				}
			}
		}

		if ( !inTeam )
		{
			if ( file.teamButtonMap[teamIndex].len() < file.teamRosters[teamIndex].teamSize )
			{
				if ( !file.playersToAdd.contains( player ) )
				{
					file.playersToAdd.append( player )
					break
				}
			}
			else
				printt( "Warning: Attempted to add ", player.GetPlayerNameWithClanTag(), " to a full team - Team:", teamIndex )
		}
	}
}

int function SortTeams( TeamDeatailsData a, TeamDeatailsData b )
{
	if ( a.teamValue < b.teamValue )
		return 1

	if ( a.teamValue > b.teamValue )
		return -1

	return 0
}

void function PrivateMatch_PopulateGameStatusMenu( var menu )
{
	if ( file.enableMenu == false )
		return

	thread UpdateTeamOverviewMenusEachSecond()                                                                        

	if ( GetLocalClientPlayer().HasMatchAdminRole() )
		thread OnPrivateMatchGameStatusThink()
}

void function PopulateOrderedTeamMap()
{
	if ( file.playersToAdd.len() > 0 )
	{
		foreach ( player in file.playersToAdd )
		{
			if ( IsValid( player ) )
				UpdateButtonData( player, player.GetTeam() )
		}

		foreach ( teamIndex, teamRoster in file.teamButtonMap )
			file.teamButtonMap[teamIndex].sort( PrivateMatch_SortButtonDataByName )

		file.playersToAdd.clear()
	}

	array< entity > players = GetPlayerArray()

	file.unorderedTeamPlayersMap.clear()
	file.teamPlayersMap.clear()

	int playerTeamMemberIndex = -1

	foreach ( player in players )
	{
		if ( !IsValid( player ) )
			continue

		if ( player.IsObserver() )
			continue

		bool inTeam = false
		int teamIndex = player.GetTeam()

		if ( !(teamIndex in file.teamPlayersMap) && (teamIndex in file.teamRosters) )
		{
			file.unorderedTeamPlayersMap[teamIndex] <- [ null, null, null ]
			file.teamPlayersMap[teamIndex] <- [ null, null, null ]
		}

		if ( !(teamIndex in file.teamButtonMap)  && (teamIndex in file.teamRosters) )
		{
			file.teamButtonMap[teamIndex] <- []
			if ( !file.playersToAdd.contains( player ) )
				file.playersToAdd.append( player )
		}
		else
		{
			Assert( file.teamButtonMap[teamIndex].len() <= file.teamRosters[teamIndex].teamSize )
			foreach ( i, buttonData in file.teamButtonMap[teamIndex] )
			{
				if ( buttonData.playerName == player.GetPlayerNameWithClanTag() )
				{
					file.teamPlayersMap[teamIndex][i] = player

					inTeam = true
					break
				}
			}
			if ( !inTeam && file.teamButtonMap[teamIndex].len() < file.teamRosters[teamIndex].teamSize )
			{
				if ( !file.playersToAdd.contains( player ) )
					file.playersToAdd.append( player )
			}
		}
		playerTeamMemberIndex = player.GetTeamMemberIndex()
		if ( playerTeamMemberIndex >= 0 && playerTeamMemberIndex < file.unorderedTeamPlayersMap[teamIndex].len() )
			file.unorderedTeamPlayersMap[teamIndex][playerTeamMemberIndex] = player
	}

	PrivateMatch_GameStatus_TeamOverview_Process()
}

void function PrivateMatch_GameStatus_TeamRoster_Configure( TeamRosterStruct teamRoster, string teamName )
{
	var buttonPanel = teamRoster.listPanel
	int teamSize    = teamRoster.teamSize

	HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
	HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )

	foreach ( button in teamRoster._listButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnRosterButton_Click )
	}

	Hud_InitGridButtons( buttonPanel, teamSize )
	var scrollPanel = Hud_GetChild( buttonPanel, "ScrollPanel" )
	for ( int i = 0; i < teamSize; i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		InitButtonRCP( button )
		HudElem_SetRuiArg( button, "buttonText", "" )
		Hud_AddEventHandler( button, UIE_CLICK, OnRosterButton_Click )

		if ( !teamRoster._listButtons.contains( button ) )
			teamRoster._listButtons.append( button )
	}
}

void function PrivateMatch_GameStatus_TeamDetails_Configure_Icons( var panel, int teamIndex )
{
	if ( !(teamIndex in file.teamPlayersMap) )
	{
		if ( teamIndex in file.teamRosters )
		{
			for ( int i = 0; i < file.teamRosters[teamIndex].teamSize; i++ )
			{
				RuiSetImage( panel, "playerImage" + i, $"" )
				RuiSetBool( panel, "playerAlive" + i, false )
			}
		}
	}
	else
	{
		array<entity> players = file.teamPlayersMap[teamIndex]
		for ( int i = 0; i < file.teamRosters[teamIndex].teamSize; i++ )
		{
			if( i <= ( players.len() -1 ) )
			{
				if( IsValid( players[i] ) )
				{
					ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( players[i] ), Loadout_Character() )
					RuiSetImage( panel, "playerImage" + i, CharacterClass_GetGalleryPortrait( character ) )
					RuiSetBool( panel, "playerAlive" + i, IsAlive( players[i] ) )
					continue
				}
			}
			RuiSetImage( panel, "playerImage" + i, $"" )
			RuiSetBool( panel, "playerAlive" + i, false )
		}
	}
}

void function PrivateMatch_GameStatus_TeamDetails_Update( array< TeamDeatailsData > teamOrderArray)
{
	if ( file.enableMenu == false )
		return
	if ( teamOrderArray.len() == 0 )
		return
	if ( file.teamOverviewPanels.len() == 0 )
		return

	if ( file.teamOneLargePanel != null )
	{
		RuiSetString( file.teamOneLargePanel, "teamName", teamOrderArray[0].teamName )
		RuiSetInt( file.teamOneLargePanel, "kills", teamOrderArray[0].teamKills )
		thread PrivateMatch_GameStatus_TeamDetails_Configure_Icons( file.teamOneLargePanel, teamOrderArray[0].teamIndex )
	}

	if ( teamOrderArray.len() == 1 )
		return

	if ( file.teamTwoLargePanel != null )
	{
		RuiSetString( file.teamTwoLargePanel, "teamName", teamOrderArray[1].teamName )
		RuiSetInt( file.teamTwoLargePanel, "kills", teamOrderArray[1].teamKills )
		thread PrivateMatch_GameStatus_TeamDetails_Configure_Icons( file.teamTwoLargePanel, teamOrderArray[1].teamIndex )
	}

	if ( teamOrderArray.len() == 2 )
		return

	for ( int i = 0; i < file.teamOverviewPanels.len(); i++ )
	{
		int teamIndex = i + 2

		if ( teamIndex < teamOrderArray.len() )
		{
			var panel = file.teamOverviewPanels[i]
			RuiSetString( panel, "teamName", teamOrderArray[teamIndex].teamName )
			RuiSetInt( panel, "playersAlive", teamOrderArray[teamIndex].playerAlive )
			RuiSetInt( panel, "kills", teamOrderArray[teamIndex].teamKills )
		}
	}
}

void function PrivateMatch_GameStatus_TeamOverview_Process()
{
	if ( file.enableMenu == false )
		return

	array< TeamDeatailsData > teamOrderArray
	
	array<entity> players

	foreach ( teamIndex, teamRoster in file.teamButtonMap )
	{
		TeamDeatailsData teamDetailsData
		teamDetailsData.teamIndex = teamIndex
		teamDetailsData.teamName = GameRules_GetTeamName( teamIndex )
		teamDetailsData.playerAlive = 0
		teamDetailsData.teamKills = 0

		if ( teamIndex in file.teamPlayersMap )
		{
			players = file.teamPlayersMap[teamIndex]
			if ( players.len() > 0 )
			{
				foreach ( playerIndex, player in file.teamPlayersMap[teamIndex] )
				{
					if ( !IsValid( player ) )
						continue

					foreach ( buttonData in file.teamButtonMap[teamIndex] )
					{
						if ( buttonData.playerName == player.GetPlayerNameWithClanTag() )
						{
							buttonData.killCount = player.GetPlayerNetInt( "kills" )
							break
						}
					}

					if ( IsAlive( player ) )
						teamDetailsData.playerAlive++
				}
			}
		}

		foreach ( buttonData in file.teamButtonMap[teamIndex] )
			teamDetailsData.teamKills += buttonData.killCount

		teamDetailsData.teamValue = ( teamDetailsData.playerAlive * 1000 ) + teamDetailsData.teamKills
		teamOrderArray.insert( teamOrderArray.len(), teamDetailsData )
	}

	teamOrderArray.sort( SortTeams )
	PrivateMatch_GameStatus_TeamDetails_Update( teamOrderArray )
}

void function PrivateMatch_GameStatus_TeamRoster_Update()
{
	if ( file.teamRosterPanel == null )
		return

	if ( file.teamRosters.len() == 0 )
		return

	if ( file.enableMenu == false )
		return

	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		array<entity> players
		if ( teamIndex in file.teamPlayersMap )
			players = file.teamPlayersMap[teamIndex]

		string teamName = GameRules_GetTeamName( teamRoster.teamIndex )

		PrivateMatch_GameStatus_TeamRoster_Configure( teamRoster, teamName )

		HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
		HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )

		var scrollPanel = Hud_GetChild( teamRoster.listPanel, "ScrollPanel" )
		Assert( players.len() <= teamRoster.teamSize )
		for ( int playerIndex = 0; playerIndex < teamRoster.teamSize; playerIndex++ )
		{
			var button = Hud_GetChild( scrollPanel, ("GridButton" + playerIndex) )
			var buttonRui = Hud_GetRui( button )
			if ( playerIndex < players.len() )
			{
				if ( IsValid( players[playerIndex] ) )
				{
					teamRoster.buttonPlayerMap[ button ] <- players[playerIndex]
					thread PrivateMatch_GameStatus_ConfigurePlayerButton( buttonRui, players[playerIndex] )
					continue
				}
			}

			if ( teamIndex in file.teamButtonMap )
			{
				if ( playerIndex < file.teamButtonMap[teamIndex].len() )
				{
					RuiSetString( buttonRui, "buttonText", file.teamButtonMap[teamIndex][playerIndex].playerName )
					RuiSetInt( buttonRui, "killCount", file.teamButtonMap[teamIndex][playerIndex].killCount )
					RuiSetImage( buttonRui, "playerPortrait", file.teamButtonMap[teamIndex][playerIndex].characterPortrait )
					RuiSetBool( buttonRui, "isConnectionQualityWidgetVisible", true )
					continue
				}
			}

			thread PrivateMatch_GameStatus_ConfigurePlayerButton( buttonRui, null )
		}
	}
}

void function PrivateMatch_GameStatus_ConfigurePlayerButton( var buttonRui, entity player )
{
	if ( player != null  )
	{
		RuiSetString( buttonRui, "buttonText",  player.GetPlayerNameWithClanTag() )
		RuiSetInt( buttonRui, "killCount", player.GetPlayerNetInt( "kills" ) )
		ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
		RuiSetImage( buttonRui, "playerPortrait", CharacterClass_GetGalleryPortrait( character ) )
		RuiSetInt( buttonRui, "playerState", GetPlayerHealthStatus( player ) )
		RuiSetBool( buttonRui, "isObserveTarget", GetLocalClientPlayer().GetObserverTarget() == player )
		RuiSetInt( buttonRui, "connectionQuality", player.GetConnectionQualityIndex() )
		RuiSetBool( buttonRui, "isConnectionQualityWidgetVisible", true )
	}
	else
	{
		RuiSetString( buttonRui, "buttonText", "" )
		RuiSetInt( buttonRui, "killCount", 0 )
		RuiSetImage( buttonRui, "playerPortrait", $"" )
		RuiSetInt( buttonRui, "playerState", ePlayerHealthStatus.PM_PLAYERSTATE_ELIMINATED )
		RuiSetBool( buttonRui, "isObserveTarget", false )
		RuiSetInt( buttonRui, "connectionQuality", 5 )
		RuiSetBool( buttonRui, "isConnectionQualityWidgetVisible", false )
	}
}

var function PrivateMatch_GameStatus_GetPlayerButton( entity player )
{
	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		foreach ( var button, entity buttonPlayer in teamRoster.buttonPlayerMap )
		{
			if ( !IsValid( button ) || !IsValid( buttonPlayer ) )
				continue

			if ( buttonPlayer == player )
			{
				return button
			}
		}
	}
}

void function OnRosterButton_Click( var button )
{
	entity observerTarget = null
	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		if ( button in teamRoster.buttonPlayerMap )
			observerTarget = teamRoster.buttonPlayerMap[ button ]
	}

	if ( !IsValid( observerTarget ) )
		return

	if ( !IsAlive( observerTarget ) )
		return

	if ( GetLocalClientPlayer().GetObserverTarget() == observerTarget )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchChangeObserverTarget", observerTarget )
	RunUIScript( "ClosePrivateMatchGameStatusMenu", null )
}

int function GetPlayerHealthStatus( entity player )
{
	int healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ALIVE

	if ( !IsAlive( player ) )
	{
		int respawnStatus = GetRespawnStatus( player )
		switch ( respawnStatus )
		{
			case eRespawnStatus.PICKUP_DESTROYED:
			case eRespawnStatus.SQUAD_ELIMINATED:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ELIMINATED
				break

			case eRespawnStatus.WAITING_FOR_DELIVERY:
			case eRespawnStatus.WAITING_FOR_DROPPOD:
			case eRespawnStatus.WAITING_FOR_PICKUP:
			case eRespawnStatus.WAITING_FOR_RESPAWN:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_DEAD
				break

			case eRespawnStatus.NONE:
			default:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ALIVE
				break
		}
	}

	if ( Bleedout_IsBleedingOut( player ) )
	{
		int bleedoutState = player.GetBleedoutState()

		switch ( bleedoutState )
		{
			case BS_BLEEDING_OUT:
			case BS_ENTERING_BLEEDOUT:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_BLEEDOUT
				break

			case BS_EXITING_BLEEDOUT:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_REVIVING
				break
		}
	}

	return healthStatus
}

void function OnGameStateEnter_Playing()
{
	TryEnablePrivateMatchGameStatusMenu()
}

void function OnPlayerMatchStateChanged( entity player, int oldState, int newState )
{
	if ( newState > ePlayerMatchState.SKYDIVE_PRELAUNCH )
	{
		TryEnablePrivateMatchGameStatusMenu()
	}
}

void function TryEnablePrivateMatchGameStatusMenu()
{
	if ( file.enableMenu )
		return

	if ( !IsPrivateMatch() )
		return

	if ( GetLocalClientPlayer().GetTeam() != TEAM_SPECTATOR )
		return

	if ( GetGameState() < eGameState.Playing )
		return

	RunUIScript( "EnablePrivateMatchGameStatusMenu", true )
	file.enableMenu = true

	PrivateMatch_PopulateGameStatusMenu( file.menu )
}

void function UpdateTeamOverviewMenusEachSecond()
{
	while ( true )
	{
		wait 1
		PopulateOrderedTeamMap()
		PrivateMatch_GameStatus_TeamRoster_Update()
	}
}

void function PrivateMatch_UpdateChatTarget()
{
	int chatMode = GetGlobalNetInt( "adminChatMode" )

	entity observerTarget = GetLocalClientPlayer().GetObserverTarget()

	if( observerTarget == null )
	{
		RunUIScript( "SetChatTargetText", "" )
	}
	else if ( chatMode == ACM_PLAYER )
	{
		RunUIScript( "SetChatTargetText", observerTarget.GetPlayerName() )
	}
	else if ( chatMode == ACM_TEAM )
	{
		RunUIScript( "SetChatTargetText", GameRules_GetTeamName( observerTarget.GetTeam() ) )
	}
	else
	{
		RunUIScript( "SetChatTargetText", "" )
	}
}

void function OnPrivateMatchGameStatusThink()
{
	int lastAdminChatMode = 0
	bool lastAdminSpectatorChat = false

	while ( true )
	{
		if ( GetGlobalNetInt( "adminChatMode" ) != lastAdminChatMode )
		{
			if( lastAdminChatMode == ACM_ALL_PLAYERS )
			{
				RunUIScript( "SetSpecatorChatModeState", false, lastAdminSpectatorChat )
			}
			
			lastAdminChatMode = GetGlobalNetInt( "adminChatMode" );
			SwitchChatModeButtonText( lastAdminChatMode )
			PrivateMatch_UpdateChatTarget()

			if( lastAdminChatMode == ACM_ALL_PLAYERS )
			{
				RunUIScript( "SetSpecatorChatModeState", true, lastAdminSpectatorChat )	
			}
		}

		if ( GetGlobalNetBool( "adminSpectatorChat" ) != lastAdminSpectatorChat )
		{
			lastAdminSpectatorChat = !lastAdminSpectatorChat
			RunUIScript( "SetSpecatorChatModeState", lastAdminChatMode == ACM_ALL_PLAYERS, lastAdminSpectatorChat )
		}
		
		WaitFrame()
	}
}

void function PrivateMatch_ToggleUpdatePlayerConnections( bool isActive )
{
	if ( isActive && file.updateConnections == false )
	{
		file.updateConnections = true
		thread UpdatePrivateMatchpPlayerConnections()
	}
	else
	{
		file.updateConnections = false
	}
}

void function UpdatePrivateMatchpPlayerConnections()
{
	while ( file.updateConnections )
	{
		foreach ( teamIndex, teamRoster in file.teamRosters )
		{
			foreach ( var button, entity buttonPlayer in teamRoster.buttonPlayerMap )
			{
				if ( IsValid( button ) )
				{
					if ( IsValid ( buttonPlayer ) )
						HudElem_SetRuiArg( button, "connectionQuality", buttonPlayer.GetConnectionQualityIndex(), eRuiArgType.INT )
					else
						HudElem_SetRuiArg( button, "connectionQuality", 5 )
				}
			}
		}
		wait 1
	}
}

#endif         


#if UI
void function OnOpenPrivateMatchGameStatusMenu()
{
	if ( !IsFullyConnected() )
	{
		CloseActiveMenu()
		return
	}
	
	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchRosterPanel" ), "#TOURNAMENT_TEAM_STATUS" )		    
		AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchOverviewPanel" ), "#TOURNAMENT_MATCH_STATS" )		    
		if ( HasMatchAdminRole() )
			AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchAdminPanel" ), "#TOURNAMENT_ADMIN_CONTROLS" )	    
		
		file.tabsInitialized = true
	}

	TabData tabData        = GetTabDataForPanel( file.menu )
	TabDef rosterTab       = Tab_GetTabDefByBodyName( tabData, "PrivateMatchRosterPanel" )
	TabDef overviewTab     = Tab_GetTabDefByBodyName( tabData, "PrivateMatchOverviewPanel" )
	if ( HasMatchAdminRole() )
		TabDef adminTab       = Tab_GetTabDefByBodyName( tabData, "PrivateMatchAdminPanel" )

	UpdateMenuTabs()

	
	ActivateTab( tabData, 0 )
		
	SetTabNavigationEnabled( file.menu, true )

	RunClientScript( "PrivateMatch_PopulateGameStatusMenu", file.menu )

}


void function OnShowPrivateMatchGameStatusMenu()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )
	if ( !HasMatchAdminRole() )
		return

	RegisterInputs()

	ControllerIconVisibilty( IsControllerModeActive() )

	RunClientScript( "PrivateMatch_ToggleUpdatePlayerConnections", true )
}

void function OnHidePrivateMatchGameStatusMenu()
{
	                                             
	if ( !HasMatchAdminRole() )
		return

	DeRegisterInputs()

	RunClientScript( "PrivateMatch_ToggleUpdatePlayerConnections", false )
}


void function OnClosePrivateMatchGameStatusMenu()
{
	if ( !HasMatchAdminRole() )
		return

	DeRegisterInputs()

	file.updateConnections = false
}


bool function CanNavigateBack()
{
	return file.disableNavigateBack != true
}


void function OnNavigateBack()
{
	ClosePrivateMatchGameStatusMenu( null )
}


void function EnablePrivateMatchGameStatusMenu( bool doEnable )
{
	file.enableMenu = doEnable
}


bool function IsPrivateMatchGameStatusMenuOpen()
{
	return GetActiveMenu() == file.menu
}

void function TogglePrivateMatchGameStatusMenu( var button )
{
	if ( !IsPrivateMatch() )
		return

	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()

	if ( file.enableMenu == true )
		AdvanceMenu( file.menu )
}


void function OpenPrivateMatchGameStatusMenu( var button )
{
	if ( !IsPrivateMatch() )
		return

	if ( file.enableMenu == false )
		return

	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function ChatModeButton_OnActivate( var button )
{
	if ( HasMatchAdminRole() )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchCycleAdminChatMode" )
	}
}

void function ChatSpectatorCheckBox_OnActivate( var button )
{
	if ( HasMatchAdminRole() )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleSpectatorChat" )
	}
}

void function ClosePrivateMatchGameStatusMenu( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}
#endif     

