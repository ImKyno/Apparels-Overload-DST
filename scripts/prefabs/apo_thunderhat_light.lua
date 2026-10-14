local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.75)
    inst.Light:SetIntensity(.9)
    inst.Light:SetColour(235/255, 121/255, 12/255)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("thunderhat_light", fn)