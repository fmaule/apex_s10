"resource/ui/menus/panels/quest.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 0"
        paintbackground         1
    }

	CenterFrame
	{
		ControlName				RuiPanel
        xpos					0
        ypos					0
        wide					1920
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

	QuestInfoBox
	{
	    ControlName				RuiPanel

	    pin_to_sibling			CenterFrame
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	TOP_LEFT
	    xpos					-250
	    ypos					-53
	    wide					1417
	    tall					683
	    visible					1
	    rui					    "ui/quest_info_box.rpak"
	}

    //////////////////////////////////////
    // REWARD BUTTONS + PURCHASE BUTTON //
    //////////////////////////////////////

    RewardsPanel
    {
        ControlName				CNestedPanel
        pin_to_sibling		    QuestInfoBox
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
        xpos					0
        ypos					0
        wide					1417    // Match size to QuestInfoBox
        tall					570 //clip the bottom of items
        visible					1
        clip                    1
        controlSettingsFile		"resource/ui/menus/panels/quest_rewards.res"
    }

    //////////////////////////////////////
    //   GRADIENT COVERING UP BOTTOM    //
    //////////////////////////////////////
    Gradient
    {
        ControlName				RuiPanel
		xpos					-1
		ypos					-520
		wide					995
		tall					50
		labelText				""
		visible					1
		paintbackground			1
		rui					    "ui/basic_image.rpak"
		proportionalToParent    1
		ruiArgs
        {
           basicImage           "rui/gradient_ud"
           basicImageAlpha      0.6
           basicImageColor      "0 0 0"
        }
		pin_to_sibling			RewardsPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
    }
	//////////////////////////////////////
	//          TODAYS REWARD           //
	//////////////////////////////////////
	TodaysReward
    {
        ControlName				RuiButton
        classname				TodaysReward
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					-106
        ypos					-311
        wide					200
        tall					200
        visible					1
        enabled					1
        navRight                RewardButton0
        navDown                 PurchaseButton
        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
    /////////////////////
    //  INTRO BUTTON   //
    /////////////////////

    IntroButton
    {
        ControlName			    RuiButton
        classname               "MenuButton"
        labelText               ""
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					-371
        ypos					-200
        wide				    464
        tall				    100
        visible                 0
        scriptID                0
        rui					    "ui/battle_pass_purchase_button.rpak"
        sound_focus             "UI_Menu_Focus_Large"
        cursorVelocityModifier  0.7
        proportionalToParent	1

        navUp AboutButton
    }

    ///////////////////
    // COMICS LOCKED //
    ///////////////////

                          
    LockedComicsPanel
    {
        ControlName				RuiPanel

        pin_to_sibling			MissionButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					0
        ypos					-41
        wide					500
        tall					40
        visible					0
        rui				        "ui/quest_locked_comics_panel.rpak"
    }
      

    ////////////////////////////////
    // FINAL MISSION REWARDS SMALL//
    ////////////////////////////////

    CompletionRewardButton1
    {
        ControlName				RuiButton
		classname				CompletionReward
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					-650
        ypos					-590
        wide					75
        tall					75
        visible					1
        enabled					1
        navRight                CompletionRewardButton2
        navUp                   RewardButton14
        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }

    CompletionRewardButton2
    {
        ControlName				RuiButton
		classname				CompletionReward
        pin_to_sibling			CompletionRewardButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					5
        ypos					0
        wide					75
        tall					75
        visible					1
        enabled					1
        navLeft                 CompletionRewardButton1
        navRight                CompletionRewardButton3
        navUp                   RewardButton14
        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }

    CompletionRewardButton3
    {
        ControlName				RuiButton
		classname				CompletionReward
        pin_to_sibling			CompletionRewardButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					5
        ypos					0
        wide					75
        tall					75
        visible					0
        enabled					1
        navLeft                 CompletionRewardButton2
        navRight                PurchaseButton
        navUp                   RewardButton14
        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
    //////////////////////////////
    // FINAL MISSION REWARDS BIG//
    //////////////////////////////
	CompletionRewardBigButton1
    {
        ControlName				RuiButton
        classname				CompletionReward
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					-541
        ypos					-309
        wide					172
        tall					172
        visible					1
        enabled					1

        navRight                CompletionRewardBigButton2

        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
    CompletionRewardBigButton2
    {
        ControlName				RuiButton
        classname				CompletionReward
        pin_to_sibling			CompletionRewardBigButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					111
        ypos					0
        wide					172
        tall					172
        visible					1
        enabled					1

        navLeft                 CompletionRewardBigButton1
        navRight                CompletionRewardBigButton3

        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
    CompletionRewardBigButton3
    {
        ControlName				RuiButton
        classname				CompletionReward
        pin_to_sibling			CompletionRewardBigButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					111
        ypos					0
        wide					172
        tall					172
        visible					1
        enabled					1

	    navLeft                 CompletionRewardBigButton2

        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
	///////////////////////
	//  PURCHASE BUTTON  //
	///////////////////////
	PurchaseButton
	{
		ControlName			    RuiButton
		classname               "MenuButton"
		labelText               ""
		xpos				    -57
		ypos				    30
		wide				    160
		tall				    50
		visible                 1
		scriptID                0
		rui					    "ui/quest_buy_box_button.rpak" // store_inspect_purchase_button
		sound_focus             "UI_Menu_Focus_Large"
		cursorVelocityModifier  0.7
		proportionalToParent	1
		pin_to_sibling			RewardsPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT

		navUp                   RewardButton20
		navLeft                 CompletionRewardButton3
	}
     ///////////////////
    // MODEL PREVIEW //
    ///////////////////

    ModelRotateMouseCapture
    {
        ControlName				CMouseMovementCapturePanel
        xpos                    0
        ypos					0
        zpos                    0
        wide                    780
        tall                    630

        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT

    }


    ///////////////////
    //  DEBUG STUFF  //
    ///////////////////

   	debugText0
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow

        xpos					1000
        ypos					150
        zpos					30
	}
	debugText1
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow
        zpos					30
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        pin_to_sibling			debugText0
	}
	debugText2
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow
        zpos					30
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        pin_to_sibling			debugText1
	}
	debugText3
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow
        zpos					30
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        pin_to_sibling			debugText2
	}
}
