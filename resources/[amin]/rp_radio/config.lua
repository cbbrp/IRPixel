radioConfig = {
    Controls = {
        Activator = { -- Open/Close Radio
            Name = "INPUT_CELLPHONE_CANCEL", -- Control name
            Key = 177, -- BackSpace665555555 
        },
        Secondary = {
            Name = "INPUT_SPRINT",
            Key = 21, -- Left Shift
            Enabled = true, -- Require secondary to be pressed to open radio with Activator
        },
        Toggle = { -- Toggle radio on/off
            Name = "INPUT_CONTEXT", -- Control name
            Key = 51, -- E
        },
        Increase = { -- Increase Frequency
            Name = "INPUT_CELLPHONE_RIGHT", -- Control name
            Key = 175, -- Right Arrow
            Pressed = false,
        },
        Decrease = { -- Decrease Frequency
            Name = "INPUT_CELLPHONE_LEFT", -- Control name
            Key = 174, -- Left Arrow
            Pressed = false,
        },
        Input = { -- Choose Frequency
            Name = "INPUT_FRONTEND_ACCEPT", -- Control name
            Key = 201, -- Enter
            Pressed = false,
        },
        Broadcast = {
            Name = "INPUT_INTERACTION_MENU", -- Control name
            Key = 244, -- Caps Lock
        },
        ToggleClicks = { -- Toggle radio click sounds
            Name = "INPUT_SELECT_WEAPON", -- Control name
            Key = 37, -- Tab
        }
    },
    Frequency = {
        Private = { -- List of private frequencies
            [911] = true, -- police 
            [912] = true, -- medic
            [916] = true, --  sheriff
            [913] = true, -- TAC 1
            [914] = true, -- TAC 2
            [915] = true, -- TAC 3
            [917] = true, -- Government
            [919] = true -- DOC
        }, -- List of private frequencies
        Current = 1, -- Don't touch
        CurrentIndex = 1, -- Don't touch
        Min = 1, -- Minimum frequency
        Max = 2500, -- Max number of frequencies
        List = {}, -- Frequency list, Don't touch
        Access = {}, -- List of freqencies a player has access to
    },
    AllowRadioWhenClosed = true -- Allows the radio to be used when not open (uses police radio animation) 
}