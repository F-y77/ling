GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

PrefabFiles = {
	"ling",
	"ling_none",
	"ling_backpack",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/ling.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/ling.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/ling.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ling.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/ling_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ling_silho.xml" ),

    Asset( "IMAGE", "bigportraits/ling.tex" ),
    Asset( "ATLAS", "bigportraits/ling.xml" ),
	
	Asset( "IMAGE", "images/map_icons/ling.tex" ),
	Asset( "ATLAS", "images/map_icons/ling.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ling.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ling.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_ling.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_ling.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_ling.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_ling.xml" ),
	
	Asset( "IMAGE", "images/names_ling.tex" ),
    Asset( "ATLAS", "images/names_ling.xml" ),
	
	Asset( "IMAGE", "images/names_gold_ling.tex" ),
    Asset( "ATLAS", "images/names_gold_ling.xml" ),

    Asset("ATLAS", "images/inventoryimages/ling_backpack.xml"),
    Asset("IMAGE", "images/inventoryimages/ling_backpack.tex"),
}

AddMinimapAtlas("images/map_icons/ling.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- 初始化LING表
STRINGS.CHARACTERS.LING = {}

-- 导入主模块
modimport("scripts/main.lua")

-- 加载角色对话文件
STRINGS.CHARACTERS.LING = require "speech_ling"

-- 角色选择界面的文本
STRINGS.CHARACTER_TITLES.ling = "气象学家"  -- 角色头衔
STRINGS.CHARACTER_NAMES.ling = "绫"  -- 角色名字
STRINGS.CHARACTER_DESCRIPTIONS.ling = "*喜欢熊猫\n*气象学家\n*冷酷中带点可爱"  -- 角色描述
STRINGS.CHARACTER_QUOTES.ling = "\"让我看看今天的天气如何？\""  -- 角色台词
STRINGS.CHARACTER_SURVIVABILITY.ling = "复杂"  -- 生存难度评级

-- 游戏内的角色名称
STRINGS.NAMES.LING = "绫"
STRINGS.SKIN_NAMES.ling_none = "绫"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("ling", "FEMALE", skin_modes)

-- 直接在这里定义配方
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local RECIPETABS = GLOBAL.RECIPETABS

-- 熊猫背包配方
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
