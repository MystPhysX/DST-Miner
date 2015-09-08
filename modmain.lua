PrefabFiles = {
	"miningmachine",
	"wrench",
	"mnzores",
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

STRINGS.NAMES.MININGMACHINEKIT_ITEM = "Mining Machine in Kit"
STRINGS.RECIPE_DESC.MININGMACHINEKIT_ITEM = "fancy recipe desc here"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MININGMACHINEKIT_ITEM = "fancy character desc here"

STRINGS.NAMES.MININGMACHINEKIT = "Mining Machine in Kit"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MININGMACHINEKIT = "fancy character desc here"

STRINGS.NAMES.MININGMACHINE = "Mining Machine or whatever"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MININGMACHINE = "fancy character desc here"

STRINGS.NAMES.MININGMACHINE_STORAGE = "Mining Machine Storage"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MININGMACHINE_STORAGE = "fancy character desc here"

STRINGS.NAMES.CRAPPYWRENCH = "DIY wrench"
STRINGS.RECIPE_DESC.CRAPPYWRENCH = "Arguable quality"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CRAPPYWRENCH = "You're kidding me?"

STRINGS.NAMES.IRONWRENCH = "Iron Wrench"
STRINGS.RECIPE_DESC.IRONWRENCH = "fancy recipe desc here"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.IRONWRENCH = "fancy character desc here"

STRINGS.NAMES.MNZIRONORE = "Iron Ore"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MNZIRONORE = "fancy character desc here"

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
	elseif target:HasTag("kit") then
		return "MOUNT"
	end
end
REPAIRMM.id = "REPAIRMM"
REPAIRMM.fn = function(act)
	local target = act.target
	local invobj = act.invobject

	print("target is ", target or "UNAVAILABLE", "and invobj is ", invobj or "UNAVAILABLE")
	print("target is jammed : ", target:HasTag("jammed"), " | target is artificially in cooldown : ", target:HasTag("cooldown"))
	if invobj and target and target:HasTag("jammed") then
		print("I unjam the machine!")
		target.components.mnzmachines.jammed = false
		invobj.components.finiteuses:Use()
	end
	
	if invobj and target and target:HasTag("kit") and target:HasTag("structure") then
		print("I mount the machine!")
		local targetx, targety, targetz = target.Transform:GetWorldPosition()
		target:Remove()
		GLOBAL.SpawnPrefab("collapse_small").Transform:SetPosition(targetx, targety, targetz)
		local mountedmachine = GLOBAL.SpawnPrefab("miningmachine")
		mountedmachine.Transform:SetPosition(targetx, targety, targetz)
		
		invobj.components.finiteuses:Use()
	end
	
	return true
end

AddAction(REPAIRMM)

local ADDSPECIALFULEMM = GLOBAL.Action(	6,		-- priority
								nil,	-- instant (set to not instant)
								nil,	-- right mouse button
								nil,	-- distance check
								nil,	-- ghost valid (set to not ghost valid)
								nil,	-- ghost exclusive
								nil,	-- can force action
								nil)	-- Range check function
ADDSPECIALFULEMM.strfn = function(act)
	if act.invobject.prefab == "mole" then
		return "ADDMOLE"
	end
end
ADDSPECIALFULEMM.id = "ADDSPECIALFULEMM"
ADDSPECIALFULEMM.fn = function(act)
    if act.doer.components.inventory then
        local fuel = act.doer.components.inventory:RemoveItem(act.invobject)
        if fuel then
            if act.target.components.mnzmachines:TakeSpecialFuelItem(fuel) then
                return true
            else
                --print("False")
                act.doer.components.inventory:GiveItem(fuel)
            end
        end
    end
end

AddAction(ADDSPECIALFULEMM)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.REPAIRMM, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.REPAIRMM, "dolongaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ADDSPECIALFULEMM, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ADDSPECIALFULEMM, "doshortaction"))

local function MnZEquippedCA(inst, doer, target, actions, right)
    if inst:HasTag("MnZmachines") and inst:HasTag("wrench") and target:HasTag("MnZmachines") and
		(target:HasTag("jammed") or (target:HasTag("kit") and target:HasTag("structure")))
		then
			table.insert(actions, ACTIONS.REPAIRMM)
	end
end

local function MnZUseitemCA(inst, doer, target, actions, right)
	if inst.prefab == "mole" and target:HasTag("MnZmachines") and not target:HasTag("kit") then
		table.insert(actions, ACTIONS.ADDSPECIALFULEMM)
    elseif inst:HasTag("MnZmachines") and inst:HasTag("wrench") and target:HasTag("MnZmachines") and
		(target:HasTag("jammed") or (target:HasTag("kit") and target:HasTag("structure")))
		then
			table.insert(actions, ACTIONS.REPAIRMM)
	end
end

AddComponentAction("EQUIPPED", "mnzmachines", MnZEquippedCA)
AddComponentAction("USEITEM", "mnzmachines", MnZUseitemCA)

GLOBAL.STRINGS.ACTIONS["REPAIRMM"] = {
	UNJAM = "Unjam the Mining Machine",
	MOUNT = "Mount the Mining Machine",
}

GLOBAL.STRINGS.ACTIONS["ADDSPECIALFULEMM"] = {
	ADDMOLE = "Funny Action Desc Here",
}

local base_deploystrfn = ACTIONS.DEPLOY.strfn

ACTIONS.DEPLOY.strfn = function(act)
	return act.invobject~= nil and
			(act.invobject:HasTag("MnZmachines") and act.invobject:HasTag("kit") and "MMKIT") or
			base_deploystrfn(act)
end

GLOBAL.STRINGS.ACTIONS.DEPLOY["MMKIT"] = "Deploy the Mining Machine Kit"

AddPrefabPostInit("mole", function(prefab)
							prefab:AddComponent("mnzmachines")	
						end
)