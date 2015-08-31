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
}