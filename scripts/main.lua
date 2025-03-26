GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- 确保PrefabFiles已初始化
PrefabFiles = PrefabFiles or {}
table.insert(PrefabFiles, "ling_backpack")

-- 导入语言文件
modimport('scripts/languages/ling_string.lua')

-- 导入容器定义
modimport("scripts/ling_widget.lua")

-- 导入其他模块
modimport("scripts/ling_asset.lua")

-- 导入配方模块
modimport("scripts/ling_recipe.lua")

-- 这里可以添加其他模块的导入 