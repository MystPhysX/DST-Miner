local assets=
{
    Asset("ANIM", "anim/wrenches.zip"),
	
	Asset("ANIM", "anim/swap_ironwrench.zip"),
		
	Asset("ATLAS", "images/inventory/crappywrench.xml"),
    Asset("IMAGE", "images/inventory/crappywrench.tex"),
	Asset("ATLAS", "images/inventory/ironwrench.xml"),
    Asset("IMAGE", "images/inventory/ironwrench.tex"),
}

prefabs = {
}

local function OnEquipWrench(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_ironwrench", "swap_"..inst.prefab)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequipWrench(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function crappywrenchfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("crappywrench")
	inst.AnimState:SetBuild("wrenches")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("wrench")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "crappywrench"
    inst.components.inventoryitem.atlasname = "images/inventory/crappywrench.xml"
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(1)
	inst.components.finiteuses:SetUses(1)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE)
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
	inst.components.equippable:SetOnEquip(OnEquipWrench)
	inst.components.equippable:SetOnUnequip(OnUnequipWrench)
	
	inst:AddComponent("mnzmachines")

	return inst	
end

local function ironwrenchfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("ironwrench")
	inst.AnimState:SetBuild("wrenches")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("wrench")
	inst:AddTag("iron")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "ironwrench"
    inst.components.inventoryitem.atlasname = "images/inventory/ironwrench.xml"
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(5) -- Configurable?
	inst.components.finiteuses:SetUses(5)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE*1.2)
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
	inst.components.equippable:SetOnEquip(OnEquipWrench)
	inst.components.equippable:SetOnUnequip(OnUnequipWrench)
	
	inst:AddComponent("mnzmachines")

	return inst	
end

return  Prefab("common/machines/ironwrench", ironwrenchfn, assets, prefabs),
		Prefab("common/machines/crappywrench", crappywrenchfn, assets, prefabs)