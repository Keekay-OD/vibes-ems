-------------------
-- CONFIG --
-------------------
Config = {}

-- General Settings
Config.Doctor = 1 -- Minimum Amount of EMS to work
Config.Price = 150 -- Price to call EMS
Config.ReviveTime = 10000  --in msec
Config.UseHelpCommand = true -- /help command to show the help message

-- Notification Settings
Config.NotifyType = "okok" -- Options: "qb", "okok", "mythic", "custom"
Config.CustomNotifyFunction = nil -- Set this to your custom notification function if NotifyType is "custom"

-- Vehicle Settings
Config.MutedSirens = false -- Set to true if you want to mute the sirens when going to the player
Config.Vehicle = "ambulance"  -- Default vehicle, Use emergency vehicle or it will cause issues

-- List of possible vehicle spawns- Hospitals parking spots are a good place to spawn vehicles
Config.VehicleSpawns = {
    "344.038, -628.424, 29.294, 250.645", --Pilllbox Hill Medical Center
    "1784.914, 3661.793, 34.216, 303.258", -- sandy shores medical center
}


-- Phone Settings
Config.UsingPhone = true -- Set to true if using a phone system
Config.Phone = "lb-phone" -- Options: "lb-phone", "qb-smartphone", "qs-smartphone"
Config.SMS = true -- Set to true if using a phone system and want to send SMS when the player is revived with the bill amount and details
Config.SMSSender = "VC Medical"  -- This is where you can change the text message sender name if using the phone. 
