local assets=
{
    Asset("ANIM", "anim/mnzores.zip"),
		
	Asset("ATLAS", "images/inventory/mnzironore.xml"),
    Asset("IMAGE", "images/inventory/mnzironore.tex"),

}

prefabs = {
}

local function mnzironorefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("ironore")
	inst.AnimState:SetBuild("mnzores")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("ore")
	inst:AddTag("molebait")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mnzironore"
    inst.components.inventoryitem.atlasname = "images/inventory/mnzironore.xml"
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 2
	
	inst:AddComponent("stackable")
    inst:AddComponent("bait")

	return inst	
end

return  Prefab("common/machines/mnzironore", mnzironorefn, assets, prefabs)