-- This information tells other players more about the mod
name = "Debug DST-Miner"
description = "Fancy Description"
author = "MystPhysx & ZupaleX"
version = "Dev 150830a"

forumthread = ""

api_version = 10

-- Can specify a custom icon for this mod!
-- icon_atlas = "modicon.xml"
-- icon = "modicon.tex"

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = true

all_clients_require_mod = true
client_only_mod = false

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {"machine", "mining"}

-- priority = 0

configuration_options =
{
	{
		name = "MMStorageSize",
		label = "Storage Capacity",
		hover = "The Amount of slots for the Mining Machine Storage",
		options =
		{
			{description = "4 slots", data = "ui_mms_2x2"},
			{description = "6 slots", data = "ui_mms_2x3"},
			{description = "9 slots", data = "ui_mms_3x3"},
			{description = "12 slots", data = "ui_mms_4x3"},
			{description = "16 slots", data = "ui_mms_4x4"},		
		},
		default = "ui_mms_2x3",
	},	
	
	{
		name = "ChestMobOdds",
		label = "Mobs in Chest",
		hover = "The probability to \"dig\" a mob long with regular items",
		options =
		{
			{description = "Never", data = 0},
			{description = "1%", data = 0.01},
			{description = "2%", data = 0.02},
			{description = "5%", data = 0.05},
			{description = "10%", data = 0.10},		
			{description = "15%", data = 0.15},	
			{description = "20%", data = 0.20},	
			{description = "25%", data = 0.25},	
			{description = "30%", data = 0.30},	
			{description = "40%", data = 0.40},	
			{description = "50%", data = 0.50},	
		},
		default = 0.05,
	},
	
	{
		name = "EscapeMobOdds",
		label = "Surface Leak",
		hover = "The probability of cave monbs to spawn next to you Mining Machine",
		options =
		{
			{description = "Never", data = 0},
			{description = "1%", data = 0.01},
			{description = "2%", data = 0.02},
			{description = "5%", data = 0.05},
			{description = "10%", data = 0.10},		
			{description = "15%", data = 0.15},	
			{description = "20%", data = 0.20},	
			{description = "25%", data = 0.25},	
			{description = "30%", data = 0.30},	
			{description = "40%", data = 0.40},	
			{description = "50%", data = 0.50},			
		},
		default = 0.05,
	},
}