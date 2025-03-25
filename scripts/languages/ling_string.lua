-- 确保能访问全局变量
local GLOBAL = GLOBAL or _G
local STRINGS = GLOBAL.STRINGS

-- 确保必要的表已经初始化
STRINGS.CHARACTERS = STRINGS.CHARACTERS or {}
STRINGS.CHARACTERS.GENERIC = STRINGS.CHARACTERS.GENERIC or {}
STRINGS.CHARACTERS.LING = STRINGS.CHARACTERS.LING or {}
STRINGS.CHARACTERS.GENERIC.DESCRIBE = STRINGS.CHARACTERS.GENERIC.DESCRIBE or {}
STRINGS.CHARACTERS.LING.DESCRIBE = STRINGS.CHARACTERS.LING.DESCRIBE or {}
STRINGS.RECIPE_DESC = STRINGS.RECIPE_DESC or {}

local msg = {
    ling_backpack = {
        name = '熊猫背包',
        ling_desc = "我最喜欢的背包，既可爱又实用！",
        desc = '一个可爱的熊猫背包',
        recipe_desc = '绫的专属背包，增加移速并保鲜食物',
    },
    -- 在这里添加更多物品
}

-- 自动设置物品名称和描述
for k, v in pairs(msg) do
    if v.name then
        STRINGS.NAMES[string.upper(k)] = v.name
        
        if v.desc then
            STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(k)] = v.desc
        end
        if v.ling_desc then
            STRINGS.CHARACTERS.LING.DESCRIBE[string.upper(k)] = v.ling_desc
        end
        if v.recipe_desc then
            STRINGS.RECIPE_DESC[string.upper(k)] = v.recipe_desc
        end
    end
end 