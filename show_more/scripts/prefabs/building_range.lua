local assets = {
    Asset("ANIM","anim/firefighter_placement.zip")
}

PLACER_SCALE = 1.5

local function OnEnableHelper(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()
    
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false
    
            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()
    
            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")
    
            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)
    
            inst.helper.AnimState:SetBank("firefighter_placement")
            inst.helper.AnimState:SetBuild("firefighter_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0, .2, .5, 0)
    
            inst.helper.entity:SetParent(inst.entity)
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
    
end

local function building_range_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.persists = false

    if not TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end

    inst.entity:SetPristine()

    return inst
end

local function placer_postinit_fn(inst)
    --Show the flingo placer on top of the flingo range ground placer

    local placer2 = CreateEntity()

    --[[Non-networked entity]]
    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / PLACER_SCALE
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("lightning_rod")
    placer2.AnimState:SetBuild("lightning_rod")
    placer2.AnimState:PlayAnimation("idle")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)
end

return  Prefab("building_range", building_range_fn, assets),
        MakePlacer("building_range_placer", "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placer_postinit_fn)