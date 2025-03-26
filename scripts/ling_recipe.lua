-- 确保能访问全局变量
local GLOBAL = GLOBAL or _G

-- 使用更可靠的方式获取游戏函数
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local AllRecipes = GLOBAL.AllRecipes

local function Injectatlas(ingredients, amount)
    local atlas = 'images/inventoryimages/' .. ingredients .. '.xml'
    return Ingredient(ingredients, amount, atlas)
end

local function Injectproductimg(product)
    local atlas = 'images/inventoryimages/' .. product .. '.xml'
    return atlas
end

-- 添加专属制作标签
local function AddRecipe2(name, ingredients, tech, config, tags)
    if not config then config = {} end
    if not tags then tags = {} end
    
    local recipe = Recipe(name, ingredients, config.tab or RECIPETABS.SURVIVAL, tech, config.placer, 
                         config.min_spacing, config.nounlock, config.numtogive, config.builder_tag, 
                         config.atlas, config.image)
    
    if tags then
        recipe.tags = tags
    end
    
    return recipe
end

