"resource/ui/menus/panels/whats_new.res"
{
	PanelFrame
	{
		ControlName				RuiPanel
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 30 255"
		visible					0
		paintbackground			1
        rui					    "ui/lobby_button_small.rpak"
        proportionalToParent    1
	}

	CenterFrame
	{
		ControlName				RuiPanel
        xpos					0
        ypos					0
        wide					1826
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 70 64"
		visible					0
		paintbackground			1
        rui					    "ui/basic_image.rpak"
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    194
        ypos                    0
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

    WhatsNewList
    {
        ControlName				GridButtonListPanel
        xpos                    194
        xpos_nx_handheld        35  [$NX || $NX_UI_PC]
        ypos                    46
        columns                 1
        rows                    12
        rows_nx_handheld        7   [$NX || $NX_UI_PC]
        buttonSpacing           6
        buttonSpacing_nx_handheld   10  [$NX || $NX_UI_PC]
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        tabPosition             0
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/whats_new_item_button.rpak"
            clipRui                 1
            wide					350
            wide_nx_handheld		630  [$NX || $NX_UI_PC]
            tall					50
            tall_nx_handheld		85   [$NX || $NX_UI_PC]
            cursorVelocityModifier  0.7
            rightClickEvents		1
			doubleClickEvents       1
			middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    ToggleHideShowLocked
    {
        ControlName			RuiButton
        clipRui             0
        xpos                0
        ypos                10
        zpos			    10
        wide			    192
        wide_nx_handheld    240			[$NX || $NX_UI_PC]
        tall			    45
        tall_nx_handheld    56			[$NX || $NX_UI_PC]
        rui					"ui/gcard_show_hide_unlocked.rpak"

        pin_to_sibling			WhatsNewList
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ActionButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					350
        wide_nx_handheld        490			[$NX || $NX_UI_PC]
        tall					110
        tall_nx_handheld		150			[$NX || $NX_UI_PC]
        xpos                    -100
        xpos_nx_handheld        -50			[$NX || $NX_UI_PC]
        ypos                    -25
        ypos_nx_handheld        25			[$NX || $NX_UI_PC]
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
}