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
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "ling_backpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "ling_backpack", "swap_body")
    
    -- 增加移动速度
    if owner.components.locomotor ~= nil then
        owner.components.locomotor:SetExternalSpeedMultiplier(inst, "ling_backpack", 1.15)
    end
    
    -- 保鲜效果
    inst.components.container:Open(owner)

    if owner:HasTag("ling") then
        owner.components.talker:Say("熊猫背包，可爱又实用~")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    
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
    inst.AnimState:SetBuild("swap_ling_backpack")--may sawp_
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
    inst:AddTag("fridge")
    inst:AddTag("nocool")
    inst:AddTag("ling_item")

    inst.MiniMapEntity:SetIcon("backpack.png")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    --防水
    inst:AddTag("waterproofer")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.imagename = "ling_backpack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ling_backpack.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ling_backpack")
    
    -- 添加保鲜功能
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0.5) -- 减缓腐烂速度50%

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
