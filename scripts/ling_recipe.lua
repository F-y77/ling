-- 确保能访问全局变量
local GLOBAL = GLOBAL or _G

-- 使用更可靠的方式获取游戏函数
-- AddRecipe 是全局函数，不是 GLOBAL 的成员
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS

local function Injectatlas(ingredients, amount)
    local atlas = 'images/inventoryimages/' .. ingredients .. '.xml'
    return Ingredient(ingredients, amount, atlas)
end

local function Injectproductimg(product)
    local atlas = 'images/inventoryimages/' .. product .. '.xml'
    return atlas
end

-- 熊猫背包配方 - 使用全局的 AddRecipe 函数
AddRecipe(
    "ling_backpack",                 -- 配方名称
    {                                -- 材料列表
        Ingredient("silk", 6),       -- 蜘蛛丝
        Ingredient("coontail", 4),   -- 浣熊尾巴
        Ingredient("bearger_fur", 1) -- 熊皮
    },
    RECIPETABS.SURVIVAL,            -- 在生存栏制作
    TECH.SCIENCE_TWO,               -- 需要科技二本
    nil,                            -- placer
    nil,                            -- min_spacing
    true,                           -- nounlock (禁用蓝图功能)
    nil,                            -- numtogive
    nil,                            -- builder_tag
    "images/inventoryimages.xml",   -- 使用游戏内置的图集
    "backpack.tex"                  -- 使用游戏内置的图标
)

-- 不要使用recipe_all表或其他复杂的配方定义方式 