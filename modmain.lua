PrefabFiles = {
	"miningmachine",
}

Assets = {
    -- Asset("IMAGE", "images/placeholder.tex"),
    -- Asset("ATLAS", "images/placeholder.xml"),

	-- Asset("SOUNDPACKAGE", "sound/placeholder.fev"),
    -- Asset("SOUND", "sound/placeholder.fsb"),
}

local require = GLOBAL.require

require("mmloottable")

local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local GIngredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH

local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local State = GLOBAL.State
local EventHandler = GLOBAL.EventHandler
local ActionHandler = GLOBAL.ActionHandler
local TimeEvent = GLOBAL.TimeEvent
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

----------------------------------------------------MOD CONFIG PARAMS------------------------------------------------

GLOBAL.TUNING.MMSTORAGESIZE = GetModConfigData("MMStorageSize")

GLOBAL.TUNING.CHESTMOBSODDS = GetModConfigData("ChestMobOdds")
GLOBAL.TUNING.ESCMOBSODDS = GetModConfigData("EscapeMobOdds")

local function ReturnTechLevel(modcfg)
	if modcfg == "NONE" then
		return TECH.NONE
	elseif modcfg == "SCIENCE_ONE" then
		return TECH.SCIENCE_ONE
	elseif modcfg == "SCIENCE_TWO" then
		return TECH.SCIENCE_TWO		
	elseif modcfg == "MAGIC_TWO" then
		return TECH.MAGIC_TWO			
	elseif modcfg == "MAGIC_THREE" then
		return TECH.MAGIC_THREE			
	end
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- local PLACEHOLDERrecipeIngredients = {}

-- PLACEHOLDERrecipeIngredients[#PLACEHOLDERrecipeIngredients + 1]= GIngredient("gears", GLOBAL.PLACEHOLDERREQGEARS);

-- AddRecipe("PLACEHOLDER", PLACEHOLDERrecipeIngredients , GLOBAL.CUSTOM_RECIPETABS.Archery, ReturnTechLevel(PLACEHOLDERTECHLEVEL), "PLACEHOLDER_placer", nil, nil, 1, nil, "images/PLACEHOLDER.xml", "PLACEHOLDER.tex")

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

STRINGS.NAMES.MININGMACHINE = "Mining Machine or whatever"
STRINGS.RECIPE_DESC.MININGMACHINE = "fancy recipe desc here"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MININGMACHINE = "fancy character desc here"

-----------------------------------------------------------------------ACTIONS--------------------------------------------------------------------------------------------------------

local REPAIRMM = GLOBAL.Action(	6,		-- priority
								nil,	-- instant (set to not instant)
								nil,	-- right mouse button
								nil,	-- distance check
								nil,	-- ghost valid (set to not ghost valid)
								nil,	-- ghost exclusive
								nil,	-- can force action
								nil)	-- Range check function
REPAIRMM.strfn = function(act)
	local target = act.target
	if target:HasTag("jammed") then
		return "UNJAM"
	end
end
REPAIRMM.id = "REPAIRMM"
REPAIRMM.fn = function(act)
	local target = act.target
	local invobj = act.invobject

	print("target is ", target or "UNAVAILABLE", "and invobj is ", invobj or "UNAVAILABLE")
	print("target is jammed : ", target:HasTag("jammed"), " | target is artificially in cooldown : ", target:HasTag("cooldown"))
	if invobj and target and target:HasTag("jammed") and target:HasTag("cooldown") then
		print("I unjam the machine!")
		target.components.mnzmachines.jammed = false
		invobj:Remove() -- To be tweaked when the wrenches will be implemented
	end
	
	return true
end

AddAction(REPAIRMM)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.REPAIRMM, "dolongaction"))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.REPAIRMM, "dolongaction"))

local function MnZUseitemCA(inst, doer, target, actions, right)
    if inst.prefab == "gears" and
        target:HasTag("MnZmachines") and target:HasTag("jammed")
		then
			table.insert(actions, ACTIONS.REPAIRMM)
	end
end

AddComponentAction("USEITEM", "mnzmachines", MnZUseitemCA)

GLOBAL.STRINGS.ACTIONS["REPAIRMM"] = {
	UNJAM = "Unjam the Mining Machine",
}

AddPrefabPostInit("gears", function(prefab) prefab:AddComponent("mnzmachines") end) -- for njamming testing purpose, I put the gear as the tool to unjam it