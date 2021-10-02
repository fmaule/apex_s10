global function UpdateArenasReportMenu
global function OpenArenasReportMenu
global function InitArenasReportMenu

struct
{
	var menu
} file

void function InitArenasReportMenu( var menu )
{
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnMenuOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )

	array<var> buttons = GetPanelElementsByClassname( file.menu, "ReportButtonMyTeam" )
	foreach ( b in buttons )
	{
		AddButtonEventHandler( b, UIE_CLICK, OnReportMyTeamClicked )

		ToolTipData td
		td.descText = "#REPORT_PLAYER"
		Hud_SetToolTipData( b, td )
	}

	buttons = GetPanelElementsByClassname( file.menu, "ReportButtonEnemyTeam" )
	foreach ( b in buttons )
	{
		AddButtonEventHandler( b, UIE_CLICK, OnReportEnemyTeamClicked )

		ToolTipData td
		td.descText = "#REPORT_PLAYER"
		Hud_SetToolTipData( b, td )
	}

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )

	var frameElem = Hud_GetChild( file.menu, "DialogFrameBG" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )

	frameElem = Hud_GetChild( file.menu, "DialogContent" )
	RuiSetString( Hud_GetRui( frameElem ), "headerText", "#REPORT_PLAYER" )
	RuiSetString( Hud_GetRui( frameElem ), "messageText", "#REPORT_PLAYER_SELECT" )
}

void function OpenArenasReportMenu()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function UpdateArenasReportMenu()
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	RunClientScript( "UICallback_ReportMenu_BindTeamHeader", Hud_GetChild( file.menu, "MyTeamHeader" ), true )
	RunClientScript( "UICallback_ReportMenu_BindTeamHeader", Hud_GetChild( file.menu, "EnemyTeamHeader" ), false )

	array<var> buttons = GetPanelElementsByClassname( file.menu, "ReportMenuMyTeam" )

	foreach ( b in buttons )
	{
		RunClientScript( "UICallback_ReportMenu_BindTeamRow", b, true )
	}

	buttons = GetPanelElementsByClassname( file.menu, "ReportMenuEnemyTeam" )

	foreach ( b in buttons )
	{
		RunClientScript( "UICallback_ReportMenu_BindTeamRow", b, false )
	}

	buttons = GetPanelElementsByClassname( file.menu, "ReportButtonMyTeam" )
	foreach ( b in buttons )
	{
		RunClientScript( "UICallback_ReportMenu_BindTeamButton", b, true )
	}

	buttons = GetPanelElementsByClassname( file.menu, "ReportButtonEnemyTeam" )
	foreach ( b in buttons )
	{
		RunClientScript( "UICallback_ReportMenu_BindTeamButton", b, false )
	}
}

void function OnMenuOpen()
{
	UpdateArenasReportMenu()
}

void function OnMenuClose()
{
	if ( !IsFullyConnected() )
		return

	RunClientScript( "UICallback_ReportMenu_OnClosed" )
}

void function OnReportEnemyTeamClicked( var button )
{
	if ( !IsFullyConnected() )
		return

	RunClientScript( "UICallback_ReportMenu_OnReportClicked", button, false )
}

void function OnReportMyTeamClicked( var button )
{
	if ( !IsFullyConnected() )
		return

	RunClientScript( "UICallback_ReportMenu_OnReportClicked", button, true )
}