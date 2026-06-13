Config = {}

-- Whether to run validation checks on menu and item data
-- Enabling this will validate the structure of the data tables returned by menu
-- and item callbacks, and print detailed error messages if the structure is
-- incorrect. This is useful for development and debugging, but will have a
-- performance impact, so it is recommended to disable it in production.
Config.Validate = false

-- Whether to enforce the usage of metadata for menu and item data
-- Enabling this will require that any key not used by the shop system is placed
-- inside the `Metadata` table of the menu or item data. This is useful for
-- ensuring that no shop system keys are accidentally used for other purposes,
-- and for checking that there are no spelling mistakes in keys.
Config.EnforceMetadata = false

-- Whether to enable the hold-to-exit functionality for menus
-- Enabling this allows the player to hold the back button to exit the menu for ease
-- of use. Menus can also individually disable this by setting `PreventHoldToExit`.
Config.HoldToExit = true

-- Configure the amount of time in miliseconds that the back button needs to be held
-- before the "Closing..." text is shown. If the user release the back button during
-- this time, the prompt will be reset to its original state, depending on the menu.
Config.HoldToExitPromptMs = 250

-- Configure the amount of time in miliseconds that the back button needs to be held
-- before the menu is actually closed. If the user release the back button during
-- this time, the prompt will be reset to its original state, depending on the menu.
Config.HoldToExitCloseMs = 1250
