PrefabFiles = {
}

Assets = {
    -- Asset("IMAGE", "images/placeholder.tex"),
    -- Asset("ATLAS", "images/placeholder.xml"),

	-- Asset("SOUNDPACKAGE", "sound/placeholder.fev"),
    -- Asset("SOUND", "sound/placeholder.fsb"),
}

local require = GLOBAL.require

local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local GIngredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH

local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS

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

local PLACEHOLDERrecipeIngredients = {}

PLACEHOLDERrecipeIngredients[#PLACEHOLDERrecipeIngredients + 1]= GIngredient("gears", GLOBAL.PLACEHOLDERREQGEARS);

AddRecipe("PLACEHOLDER", PLACEHOLDERrecipeIngredients , GLOBAL.CUSTOM_RECIPETABS.Archery, ReturnTechLevel(PLACEHOLDERTECHLEVEL), "PLACEHOLDER_placer", nil, nil, 1, nil, "images/minimap/PLACEHOLDER.xml", "PLACEHOLDER.tex")

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

STRINGS.NAMES.PLACEHOLDER = "placeholder"
STRINGS.RECIPE_DESC.PLACEHOLDER = "placeholder"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PLACEHOLDER = "placeholder"