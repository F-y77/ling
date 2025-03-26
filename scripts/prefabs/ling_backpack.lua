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
local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/movement/foley/backpack")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/movement/foley/backpack")
end

local function onequip(inst, owner)
    --owner.AnimState:OverrideSymbol("backpack", "ling_backpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_object", "swap_ling_backpack", "swap_ling_backpack")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    -- 增加移动速度
    if owner.components.locomotor ~= nil then
        owner.components.locomotor:SetExternalSpeedMultiplier(inst, "ling_backpack", 1.15)
    end
    
    inst.components.container:Open(owner)

    if owner:HasTag("ling") then
        owner.components.talker:Say("熊猫背包，可爱又实用~")
    end
end

local function onunequip(inst, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    inst.components.container:Close()
    
    -- 移除移动速度加成
    if owner.components.locomotor ~= nil then
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ling_backpack")
    end
    
    inst.components.container:Close(owner)
end

local function onequiptomodel(inst, owner, from_ground)
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
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
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ling_backpack")
    inst.AnimState:SetBuild("ling_backpack")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("backpack")
    inst:AddTag("fridge")
    inst:AddTag("nocool")
    inst:AddTag("ling_item")
    inst:AddTag("waterproofer")

    inst.MiniMapEntity:SetIcon("backpack.png")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.imagename = "ling_backpack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ling_backpack.xml"
    inst.components.inventoryitem.keepondeath = true  -- 死亡不掉落

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    --inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED  -- 装备增加理智恢复
    --[[if TUNING.LING_BACKPACK_SWAP == 1 then
        inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    else
        inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    end]]
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE/2 --装备回复san

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

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0.2)  -- 20%防水效果

    return inst
end

return Prefab("ling_backpack", fn, assets, prefabs)
