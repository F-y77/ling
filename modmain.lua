GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

PrefabFiles = {
	"ling",
	"ling_none",
	"ling_backpack",
}

Assets = {
    --存档图片
    Asset( "IMAGE", "images/saveslot_portraits/ling.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/ling.xml" ),

    --选择角色图片-已拥有
    Asset( "IMAGE", "images/selectscreen_portraits/ling.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ling.xml" ),
	
    --选择角色图片-未拥有
    Asset( "IMAGE", "images/selectscreen_portraits/ling_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ling_silho.xml" ),

    --大头像-角色选择界面
    Asset( "IMAGE", "bigportraits/ling.tex" ),
    Asset( "ATLAS", "bigportraits/ling.xml" ),
	
    --地图图标
	Asset( "IMAGE", "images/map_icons/ling.tex" ),
	Asset( "ATLAS", "images/map_icons/ling.xml" ),
	
    --TAP键位显示的人物头像
	Asset( "IMAGE", "images/avatars/avatar_ling.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ling.xml" ),
	
    --TAP键位显示的幽灵头像
	Asset( "IMAGE", "images/avatars/avatar_ghost_ling.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_ling.xml" ),
	
    --自检头像，人物检查界面头像
	Asset( "IMAGE", "images/avatars/self_inspect_ling.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_ling.xml" ),
	
    --名字
	Asset( "IMAGE", "images/names_ling.tex" ),
    Asset( "ATLAS", "images/names_ling.xml" ),

    --金色名字
	Asset( "IMAGE", "images/names_gold_ling.tex" ),
    Asset( "ATLAS", "images/names_gold_ling.xml" ),

    --背包
    Asset("ATLAS", "images/inventoryimages/ling_backpack.xml"),
    Asset("IMAGE", "images/inventoryimages/ling_backpack.tex"),
}

-- 添加地图图标
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

-- 熊猫背包配方 - 使用专属制作标签
AddRecipe2(
    "ling_backpack",                 -- 配方名称
    {                                -- 材料列表
        Ingredient("silk", 6),       -- 蜘蛛丝
        Ingredient("coontail", 4),   -- 浣熊尾巴
        Ingredient("bearger_fur", 1) -- 熊皮
    },
    TECH.SCIENCE_TWO,               -- 需要科技二本
    {
        builder_tag = "ling_build",  -- 只有绫可以制作
        atlas = "images/inventoryimages/ling_backpack.xml", 
        image = "ling_backpack.tex"
    }, 
    {"CHARACTER", "CLOTHING"}        -- 分类标签
)

-- 不要使用recipe_all表或其他复杂的配方定义方式 

-- 熊皮制作配方 - 消耗100滴血
AddRecipe2(
    "bearger_fur",                  -- 配方名称
    {                               -- 材料列表
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 100)  -- 消耗100点生命值
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
        atlas = "images/inventoryimages.xml",
        image = "bearger_fur.tex"
    },
    {"CHARACTER"}                   -- 分类标签
)

-- 猫尾制作配方 - 消耗15滴血
AddRecipe2(
    "coontail",                     -- 配方名称
    {                               -- 材料列表
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 15)  -- 消耗15点生命值
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
        atlas = "images/inventoryimages.xml",
        image = "coontail.tex"
    },
    {"CHARACTER"}                   -- 分类标签
)

-- 火把制作配方 - 消耗1个树枝和5点精神值
AddRecipe2(
    "torch",                        -- 配方名称
    {                               -- 材料列表
        Ingredient("twigs", 1),     -- 1个树枝
        Ingredient(CHARACTER_INGREDIENT.SANITY, 5)  -- 消耗5点精神值
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
    },
    {"CHARACTER", "LIGHT"}          -- 分类标签
)

-- 噩梦燃料制作配方 - 消耗20点精神值
AddRecipe2(
    "nightmarefuel",                -- 配方名称
    {                               -- 材料列表
        Ingredient(CHARACTER_INGREDIENT.SANITY, 10)  -- 消耗10点精神值
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
    },
    {"CHARACTER", "REFINE"}         -- 分类标签
)

-- 兔毛配方 - 消耗30滴血
AddRecipe2(
    "manrabbit_tail",                   -- 配方名称
    {                               -- 材料列表
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 30)  -- 消耗30点生命值
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
        atlas = "images/inventoryimages.xml",
        image = "manrabbit_tail.tex"
    },
    {"CHARACTER"}                   -- 分类标签
)

-- 蜘蛛网配方 - 消耗10滴血和5点精神值
AddRecipe2(
    "silk",                         -- 配方名称
    {                               -- 材料列表
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 10),  -- 消耗10点生命值
        Ingredient(CHARACTER_INGREDIENT.SANITY, 5)    -- 消耗5点精神值
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
    },
    {"CHARACTER", "REFINE"}         -- 分类标签
)

-- 治疗药膏配方 - 消耗5滴血和2个石头
AddRecipe2(
    "healingsalve",                 -- 配方名称
    {                               -- 材料列表
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 5),  -- 消耗5点生命值
        Ingredient("rocks", 2)                       -- 2个石头
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
    },
    {"CHARACTER", "RESTORATION"}    -- 分类标签
)

-- 扑腾绷带配方 - 消耗1个蝴蝶翅膀和5点精神值
AddRecipe2(
    "bandage_butterflywings",                      -- 配方名称
    {                               -- 材料列表
        Ingredient("butterflywings", 1),             -- 1个蝴蝶翅膀
        Ingredient(CHARACTER_INGREDIENT.SANITY, 10)   -- 消耗5点精神值
    },
    TECH.NONE,                      -- 不需要科技
    {
        builder_tag = "ling_build", -- 只有绫可以制作
        no_deconstruction = true,   -- 不能拆解
        actionstr = "制作",         -- 制作按钮文本
    },
    {"CHARACTER", "RESTORATION"}    -- 分类标签
)

-- 更新配方描述
STRINGS.RECIPE_DESC.BEARGER_FUR = "消耗100点生命值制作熊皮"
STRINGS.RECIPE_DESC.COONTAIL = "消耗15点生命值制作猫尾"
STRINGS.RECIPE_DESC.TORCH = "消耗1个树枝和5点精神值制作火把"
STRINGS.RECIPE_DESC.NIGHTMAREFUEL = "消耗10点精神值制作噩梦燃料"
STRINGS.RECIPE_DESC.MANRABBIT_TAIL = "消耗30点生命值制作兔毛"
STRINGS.RECIPE_DESC.SILK = "消耗10点生命值和5点精神值制作蜘蛛网"