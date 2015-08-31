local assets=
{
    Asset("ANIM", "anim/miningmachine.zip"),
}

prefabs = {
}

local function miningmachinefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	-- inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("placeholder")
	inst.AnimState:SetBuild("placeholder")
	inst.AnimState:PlayAnimation("placeholder")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	

	return inst
end

return  Prefab("common/machines/miningmachine", miningmachinefn, assets, prefabs),