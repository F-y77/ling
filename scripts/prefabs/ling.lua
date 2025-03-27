local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- 角色属性设置
TUNING.LING_HEALTH = 150  -- 绫的生命值
TUNING.LING_HUNGER = 150  -- 绫的饥饿值
TUNING.LING_SANITY = 300  -- 绫的精神值，作为气象学家，精神值较高

-- 自定义起始物品
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.LING = {
	"staff_tornado",  -- 天气风向标
	"opalpreciousgem",  -- 彩虹宝石
	"book_brimstone",  -- 末日将至
	"book_rain",  -- 使用求雨指南
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.LING
end
local prefabs = FlattenTree(start_inv, true)

-- 当角色从鬼魂状态复活时
local function onbecamehuman(inst)
	-- 设置非鬼魂状态下的速度修饰符（可选）
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ling_speed_mod", 1)
    
    -- 恢复免疫潮湿度
    inst.components.moisture:SetInherentWaterproofness(1)
    
    -- 恢复寒冷值
    if inst.components.temperature ~= nil then
        inst.components.temperature:SetTemperature(10)
    end
end

local function onbecameghost(inst)
	-- 成为鬼魂时移除速度修饰符
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ling_speed_mod")
    
    -- 鬼魂状态下不再免疫潮湿度
    inst.components.moisture:SetInherentWaterproofness(0)
end

-- 加载或生成角色时
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

-- 将SetFriendlyToCreatures函数的逻辑移动到modmain.lua中
local function SetFriendlyToCreatures(inst)
    -- 添加与特定生物友好的标签
    inst:AddTag("rabbit_friend")      -- 兔子
    inst:AddTag("raccoon_friend")     -- 浣熊
    inst:AddTag("bearger_friend")     -- 熊大
    inst:AddTag("pig_friend")         -- 猪人
    inst:AddTag("merm_friend")        -- 鱼人
    inst:AddTag("manrabbit_friend")   -- 兔人
    
    -- 监听生物的攻击事件，阻止特定生物攻击绫
    inst:ListenForEvent("attacked", function(inst, data)
        local attacker = data.attacker
        if attacker and (
            attacker:HasTag("rabbit") or 
            attacker:HasTag("raccoon") or 
            attacker:HasTag("bearger") or 
            attacker:HasTag("pig") or 
            attacker:HasTag("merm") or 
            attacker:HasTag("manrabbit")
        ) then
            -- 取消攻击
            if attacker.components.combat then
                attacker.components.combat:SetTarget(nil)
            end
            
            -- 可选：让生物表示友好
            if attacker.components.talker then
                attacker.components.talker:Say("绫是我们的朋友！")
            end
        end
    end)
end

-- 这个函数在服务器和客户端都会初始化。可以在这里添加标签。
local common_postinit = function(inst) 
	-- 小地图图标
	inst.MiniMapEntity:SetIcon("ling.tex")
    
    -- 添加免疫潮湿的标签
    inst:AddTag("waterproofer")
    inst:AddTag("ling")
    
    -- 添加新的能力标签
    inst:AddTag("bookbuilder")      -- 可以制作老奶奶的书
    inst:AddTag("masterchef")       -- 可以使用大厨的锅
    inst:AddTag("balloonomancer")   -- 可以制作维斯的气球
    inst:AddTag("pyromaniac")       -- 可以制作薇洛的打火机
end

-- 这个函数只在服务器上初始化。在这里添加组件。
local master_postinit = function(inst)
	-- 设置起始物品
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- 选择角色使用的声音
	inst.soundsname = "willow"  -- 使用薇洛的声音
	
	-- 如果使用"wathgrithr"(薇格弗德)或"webber"(韦伯)的声音，取消下面这行的注释
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- 属性设置
	inst.components.health:SetMaxHealth(TUNING.LING_HEALTH)
	inst.components.hunger:SetMax(TUNING.LING_HUNGER)
	inst.components.sanity:SetMax(TUNING.LING_SANITY)
	
	-- 伤害倍率（可选）
    inst.components.combat.damagemultiplier = 1  -- 标准伤害倍率
	
	-- 饥饿速率（可选）
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE  -- 标准饥饿速率

	--可以读书
	inst:AddComponent("reader") 

	--回San光环
	inst:AddComponent("sanityaura") 
	inst.components.sanityaura.aura = 2 * TUNING.SANITYAURA_MED
	
	-- 根据设定，绫是气象学家，可以考虑后续添加与天气相关的特殊能力
	-- 例如：暖雨、酸雨、晴天、阴天等天气魔法
	
	-- 根据设定，绫喜欢熊猫，可以考虑添加熊猫相关的特殊物品制作
	-- 例如：熊猫背包（增加10%移速的小偷背包）
	
	-- 根据设定，绫可以制作特殊武器
	-- 例如：汵风（小刀，附带吸血效果）和冷风（太刀，附带冰冻效果）
	
	-- 添加专属制作标签
	inst:AddTag("ling_build")
    
    -- 设置完全防水
    inst.components.moisture:SetInherentWaterproofness(1)
    
    -- 设置初始温度（10点寒冷值）
    if inst.components.temperature ~= nil then
        inst.components.temperature:SetTemperature(10)
    end
    
    -- 设置与特定生物的友好关系
    SetFriendlyToCreatures(inst)
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("ling", prefabs, assets, common_postinit, master_postinit, prefabs) 