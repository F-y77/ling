local assets =
{
    Asset("ANIM", "anim/ling_backpack.zip"),
    Asset("ANIM", "anim/swap_ling_backpack.zip"),
    Asset("ATLAS", "images/inventoryimages/ling_backpack.xml"),
    Asset("IMAGE", "images/inventoryimages/ling_backpack.tex"),
}
local prefabs =
{
    "ash",
} --掉落物灰

-- 熊猫背包特殊效果：增加理智值恢复
local function ling_backpack_disable(inst)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end
end

local function ling_backpack_update(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    
    if owner then
        -- 只保留移动速度加成
        if owner:HasTag("ling") and owner.components.locomotor then
            owner.components.locomotor:SetExternalSpeedMultiplier(inst, "ling_backpack_bonus", 1.05)
        end
    end
end

local function ling_backpack_enable(inst)
    inst.updatetask = inst:DoPeriodicTask(1, ling_backpack_update)
end

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/movement/foley/backpack")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/movement/foley/backpack")
end

--[[local function NoSanitySound(inst)
    if inst.SoundEmitter then
        -- 禁用理智恢复声音
        local old_PlaySound = inst.SoundEmitter.PlaySound
        inst.SoundEmitter.PlaySound = function(self, sound, ...)
            if sound:find("sanity") then
                return
            end
            return old_PlaySound(self, sound, ...)
        end
    end
end]]

local function onequip(inst, owner)
    -- 关键修改：使用正确的动画覆盖方式
    owner.AnimState:OverrideSymbol("swap_object", "swap_ling_backpack", "swap_ling_backpack")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    
    -- 增加移动速度
    if owner.components.locomotor ~= nil then
        owner.components.locomotor:SetExternalSpeedMultiplier(inst, "ling_backpack", 1.15)
    end
    
    -- 打开容器
    inst.components.container:Open(owner)
    ling_backpack_enable(inst)

    if owner:HasTag("ling") then
        owner.components.talker:Say("熊猫背包，可爱又实用~")
    end

    -- 禁用理智恢复声音
    --NoSanitySound(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    
    -- 移除移动速度加成
    if owner.components.locomotor ~= nil then
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ling_backpack")
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ling_backpack_bonus")
    end
    
    -- 关闭容器
    inst.components.container:Close()
    ling_backpack_disable(inst)
end

local function onequiptomodel(inst, owner, from_ground)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ling_backpack")
    inst.AnimState:SetBuild("ling_backpack")
    inst.AnimState:PlayAnimation("idle")
    
    -- 可以设置缩放比例
    inst.AnimState:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("backpack")
    inst:AddTag("ling_backpack")  -- 添加特定标签
    inst:AddTag("fridge")
    inst:AddTag("nocool")
    inst:AddTag("ling_item")
    inst:AddTag("waterproofer")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "ling_backpack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ling_backpack.xml"
    inst.components.inventoryitem.keepondeath = true  -- 死亡不掉落

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY  -- 改为身体装备
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED -- 使用游戏内置的理智恢复机制，这样也不会有噪音。

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ling_backpack")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    
    -- 添加保鲜功能
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0.5) -- 减缓腐烂速度50%

    -- 添加保暖功能
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

    -- 添加领导者组件，为将来可能添加的特殊功能做准备
    inst:AddComponent("leader")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunch(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0.2)  -- 20%防水效果

    return inst
end

return Prefab("ling_backpack", fn, assets, prefabs)
