PrefabFiles = {
	"xiongguan",
}

Assets = 
{   
	Asset("ATLAS", "images/inventoryimages/xiongguan.xml"),
}

AddMinimapAtlas("images/map_icons/xiongguan.xml") 


local STRINGS = GLOBAL.STRINGS                                       
local RECIPETABS = GLOBAL.RECIPETABS
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH

STRINGS.NAMES.XIONGGUAN = "Big Bear Stick"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XIONGGUAN = "A weapon made of flaming fur"
STRINGS.RECIPE_DESC.XIONGGUAN = "Flush weapons"

local xiongguan = GLOBAL.Recipe("xiongguan", { Ingredient("hambat", 1),Ingredient("houndstooth", 4),Ingredient("goldnugget", 4)}, RECIPETABS.WAR, TECH.SCIENCE_TWO)
xiongguan.atlas = "images/inventoryimages/xiongguan.xml"
