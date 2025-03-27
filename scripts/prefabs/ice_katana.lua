local assets = {
    -- 武器的贴图资源
    Asset("ANIM", "anim/ice_katana.zip"),         -- 拿在手上的动画
    Asset("ANIM", "anim/ice_katana_ground.zip"),  -- 放在地上的动画
    Asset("ATLAS", "images/inventoryimages/ice_katana.xml"),
    Asset("IMAGE", "images/inventoryimages/ice_katana.tex"),
}

local prefabs = {
    "ice_projectile",  -- 冰冻效果的投射物
}

-- 冰冻效果函数
local function OnAttack(inst, attacker, target)
    if target ~= nil and target:IsValid() and target.components.freezable ~= nil then
        -- 有30%几率冰冻目标
        if math.random() < 0.3 then
            target.components.freezable:AddColdness(1)
            target.components.freezable:SpawnShatterFX()
            -- 播放冰冻音效
            if attacker ~= nil and attacker.SoundEmitter ~= nil then
                attacker.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
            end
        end
    end
end

local function onequip(inst, owner)
    -- 只有绫可以装备
    if owner.prefab ~= "ling" then
        -- 如果不是绫装备，立即卸下
        owner.components.inventory:DropItem(inst)
        if owner.components.talker then
            owner.components.talker:Say("这把太刀只有绫才能使用。")
        end
        return
    end

    owner.AnimState:OverrideSymbol("swap_object", "ice_katana", "swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    
    -- 装备效果
    if owner.components.combat then
        -- 增加攻击距离到2米
        owner.components.combat.attackrange = 2
    end
    
    -- 增加移动速度10%
    if owner.components.locomotor then
        owner.components.locomotor:SetExternalSpeedMultiplier(inst, "ice_katana", 1.1)
    end
    
    -- 增加冰冻抗性
    if owner.components.temperature then
        owner.components.temperature.inherentinsulation = owner.components.temperature.inherentinsulation + 60
    end
    
    if owner:HasTag("ling") then
        owner.components.talker:Say("冷风在手，天下我有！")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    
    -- 移除装备效果
    if owner.components.combat then
        -- 恢复攻击距离
        owner.components.combat.attackrange = 1
    end
    
    -- 移除移动速度加成
    if owner.components.locomotor then
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ice_katana")
    end
    
    -- 移除冰冻抗性
    if owner.components.temperature then
        owner.components.temperature.inherentinsulation = owner.components.temperature.inherentinsulation - 60
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    -- 设置放地上的动画 - 使用正确的地面动画文件
    inst.AnimState:SetBank("ice_katana_ground")
    inst.AnimState:SetBuild("ice_katana_ground")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("ice_katana")
    inst:AddTag("ling_item")  -- 标记为绫的专属物品

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- 添加组件
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(77)  -- 设置伤害为77
    inst.components.weapon:SetRange(2)    -- 设置攻击范围为2米
    inst.components.weapon:SetOnAttack(OnAttack)  -- 设置攻击回调

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ice_katana.xml"
    inst.components.inventoryitem.imagename = "ice_katana"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    -- 添加冰冻效果
    inst:AddComponent("temperature")
    inst.components.temperature.current = 0
    inst.components.temperature.mintemp = 0

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("ice_katana", fn, assets, prefabs) 