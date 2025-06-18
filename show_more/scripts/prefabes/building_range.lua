local assets = {
    Asset("ANIM","anim/building_range.zip")
}

PLACER_SCALE = 1.5

local function OnEnableHelper(inst, enabled)
    print("inst -->", inst)
    print("enabled -->", enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()
    
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false
    
            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAddAnimState()
    
            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")
    
            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)
    
            inst.helper.AnimState:SetBank("building_range")
            inst.helper.AnimState:SetBuild("building_range")
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

    return inst
end

return Prefab("building_range", building_range_fn, assets)