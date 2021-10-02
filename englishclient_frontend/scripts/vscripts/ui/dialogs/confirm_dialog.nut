global function InitConfirmDialog
global function InitOKDialog

global function OpenConfirmDialogFromData
global function OpenABDialogFromData
global function OpenOKDialogFromData

enum eDialogType
{
	CONFIRM,
	AB,
	OK,
}

global enum eDialogResult
{
	CANCEL
	YES
	NO
}

struct
{
	var confirmMenu
	var okMenu
	var contentRui

	ConfirmDialogData ornull showDialogData
	array<ConfirmDialogData> showDialogDataQueue
} file

void function InitConfirmDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ConfirmDialog" )
	file.confirmMenu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmDialog_OnNavigateBack )
}


void function InitOKDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "OKDialog" )
	file.okMenu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmDialog_OnNavigateBack )
}


void function OpenConfirmDialogFromData( ConfirmDialogData dialogData )
{
	Assert( dialogData.resultCallback != null, "resultCallback == null; this dialog won't do anything" )

	dialogData.dialogType = eDialogType.CONFIRM
	dialogData.__menu = file.confirmMenu
	if(file.showDialogData == null)
	{
		file.showDialogData = dialogData
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}
	else
	{
		file.showDialogDataQueue.push(dialogData)
	}
}


void function OpenABDialogFromData( ConfirmDialogData dialogData )
{
	Assert( dialogData.resultCallback != null, "resultCallback == null; this dialog won't do anything" )

	dialogData.dialogType = eDialogType.AB
	dialogData.__menu     = file.confirmMenu

	if(file.showDialogData == null)
	{
		file.showDialogData = dialogData
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}
	else
	{
		file.showDialogDataQueue.push(dialogData)
	}
}


void function OpenOKDialogFromData( ConfirmDialogData dialogData )
{
	dialogData.dialogType = eDialogType.OK
	dialogData.__menu = file.okMenu

	if(file.showDialogData == null)
	{
		file.showDialogData = dialogData

		AdvanceMenu( GetMenu( "OKDialog" ) )
	}
	else
	{
		file.showDialogDataQueue.push(dialogData)
	}
}


void function Dialog_OnOpen()
{
	Assert( file.showDialogData != null )

	ClearMenuFooterOptions( _confirmData().__menu )
	var contentRui = Hud_GetRui( Hud_GetChild( _confirmData().__menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", _confirmData().headerText )
	RuiSetString( contentRui, "messageText", _confirmData().messageText )
	RuiSetAsset( contentRui, "contextImage", _confirmData().contextImage )

	                                                                                                 
	RuiSetFloat( contentRui, "delayPenaltyWarnTime", _confirmData().timePenaltyWarning )
	RuiSetGameTime( contentRui, "endTime", _confirmData().timerEndTime )

	if ( _confirmData().dialogType == eDialogType.CONFIRM )
	{
		AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_A, true, _confirmData().yesText[0], _confirmData().yesText[1], ConfirmDialog_Yes )
		AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_B, true, _confirmData().noText[0], _confirmData().noText[1], ConfirmDialog_No )
	}
	else if ( _confirmData().dialogType == eDialogType.AB )
	{
		AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_X, true, _confirmData().yesText[0], _confirmData().yesText[1], ConfirmDialog_Yes )
		AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_Y, true, _confirmData().noText[0], _confirmData().noText[1], ConfirmDialog_No )
	}
	else
	{
		if ( _confirmData().yesText[0] != "" )
			AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_B, true, _confirmData().okText[0], _confirmData().okText[1], ConfirmDialog_Yes )
	}
}


ConfirmDialogData function _confirmData()
{
	Assert( file.showDialogData != null )
	return expect ConfirmDialogData( file.showDialogData )
}


void function ConfirmDialog_OnClose()
{
	file.showDialogData = null
	CheckQueue()
}


void function ConfirmDialog_OnNavigateBack()
{
	ConfirmDialogData confirmData = _confirmData()
	CloseActiveMenu()
	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.CANCEL )
}


void function ConfirmDialog_Yes( var button )
{
	                                                                           
	if ( file.showDialogData == null )
		return

	ConfirmDialogData confirmData = _confirmData()

	if ( confirmData.extendedUseYes )
	{
		var holdToUseElem = Hud_GetChild( confirmData.__menu, "HoldToUseElem" )
		bool requiresButtonFocus = false
		float duration = 1.2
		StartMenuExtendedUse( button, holdToUseElem, duration, requiresButtonFocus, void function( bool success ) : ( button ) {
			if ( success )
				ConfirmDialog_Yes_PassThrough( button )
		} )
	}
	else
	{
		ConfirmDialog_Yes_PassThrough( button )
	}
}

void function ConfirmDialog_Yes_PassThrough( var button )
{
	ConfirmDialogData confirmData = _confirmData()

	var menu = GetActiveMenu()
	if ( GetActiveMenu() == confirmData.__menu )
		CloseActiveMenu()

	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.YES )
}


void function ConfirmDialog_No( var button )
{
	                                                                           
	if ( file.showDialogData == null )
		return

	ConfirmDialogData confirmData = _confirmData()
	if ( GetActiveMenu() == confirmData.__menu )
		CloseActiveMenu()

	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.NO )
}

void function CheckQueue(){
	if(file.showDialogDataQueue.len() > 0)
	{
		ConfirmDialogData poppedData = file.showDialogDataQueue.remove(0)
		file.showDialogData = poppedData
		if(poppedData.dialogType == eDialogType.OK)
			AdvanceMenu( GetMenu( "OKDialog" ) )
		else if(poppedData.dialogType == eDialogType.AB)
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
		else if(poppedData.dialogType == eDialogType.CONFIRM)
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
		else
			Warning( "Unknown Dialog type" )
	}
}