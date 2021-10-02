"resource/ui/menus/panels/quest_rewards.res"
{
	////////////////////
	// REWARD BUTTONS //
	////////////////////

	//row 1
	RewardButton0
	{
		ControlName				RuiButton
		classname				RewardButton
		xpos					484
		ypos				    244

		navLeft                 TodaysReward
		navUp                   MissionButton0
		navRight                RewardButton1
		navDown                 RewardButton7

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton1
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					20
		ypos					0
		navUp                   MissionButton0
		navLeft                 RewardButton0
		navRight                RewardButton2
		navDown                 RewardButton8

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton2
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					20
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton1
		navRight                RewardButton3
		navDown                 RewardButton9

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton3
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					20
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton2
		navRight                RewardButton4
		navDown                 RewardButton10

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton4
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					20
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton3
		navRight                RewardButton5
		navDown                 RewardButton11

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton5
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					20
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton4
		navRight                RewardButton6
		navDown                 RewardButton12

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton6
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					20
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton5
		navRight                RewardButton7
		navDown                 RewardButton13

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}


	//row 2
	RewardButton7
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
        xpos					0
        ypos					20

        navUp                   RewardButton0
        navLeft                 RewardButton6
		navRight                RewardButton8
        navDown                 RewardButton14

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
	RewardButton8
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton7
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
		xpos					20
        ypos					0

		navUp                   RewardButton1
        navLeft                 RewardButton7
        navRight                RewardButton9
        navDown                 RewardButton15

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}
	RewardButton9
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton8
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton2
        navLeft                 RewardButton8
        navRight                RewardButton10
        navDown                 RewardButton16

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton10
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton9
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton3
        navLeft                 RewardButton9
        navRight                RewardButton11
        navDown                 RewardButton17

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton11
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton10
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton4
        navLeft                 RewardButton10
        navRight                RewardButton12
        navDown                 RewardButton18

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton12
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton11
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton5
        navLeft                 RewardButton11
        navRight                RewardButton13
        navDown                 RewardButton19

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton13
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton12
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton6
        navLeft                 RewardButton12
        navRight                RewardButton14
        navDown                 RewardButton20

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }

	//row 3
	RewardButton14
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton7
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
        xpos					0
        ypos					20

        navUp                   RewardButton7
        navLeft                 RewardButton13
        navRight                RewardButton15
        navDown                 CompletionRewardBigButton1

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
	RewardButton15
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton14
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
		xpos					20
        ypos					0

		navUp                   RewardButton8
        navLeft                 RewardButton14
        navRight                RewardButton16
        navDown                 CompletionRewardBigButton1

		wide					108
		tall					108
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}
	RewardButton16
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton15
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton9
        navLeft                 RewardButton15
        navRight                RewardButton17
        navDown                 CompletionRewardBigButton1

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton17
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton16
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton10
        navLeft                 RewardButton16
        navRight                RewardButton18
        navDown                 CompletionRewardBigButton1

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton18
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton17
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton11
        navLeft                 RewardButton17
        navRight                RewardButton19
        navDown                 CompletionRewardBigButton1

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton19
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton18
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton12
        navLeft                 RewardButton18
        navRight                RewardButton20
        navDown                 PurchaseButton

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton20
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton19
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					20
        ypos					0

		navUp                   RewardButton13
        navLeft                 RewardButton19
        navDown                 PurchaseButton

        wide					108
        tall					108
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
}