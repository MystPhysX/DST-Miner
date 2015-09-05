local assets=
{
    Asset("ANIM", "anim/miningmachine.zip"),
	
	Asset("ANIM", "anim/ui_mms.zip"),
	
	Asset("ATLAS", "images/inventory/miningmachinekit.xml"),
    Asset("IMAGE", "images/inventory/miningmachinekit.tex"),
}

prefabs = {
}

require "prefabutil"

-----------------------------------------------------------THE MACHINE ITSELF-----------------------------------------------------

local function GetMMStorage(inst)
	print("I check for an existing storage")
	local instposx, instposy, instposz = inst.Transform:GetWorldPosition()
	local nearbyents = TheSim:FindEntities(instposx, instposy, instposz, 3, { "MnZmachines" , "storage" })
	
	local foundmmstorage = nil
	for k, v in pairs(nearbyents) do
		print(k, " / ", v)
		if v:IsValid() then
			foundmmstorage = v
		end
	end
	
	if foundmmstorage == nil then
		inst.mmstorage = SpawnPrefab("miningmachine_storage")
		print("No storage found, I create a new one : ", inst.mmstorage)
	else
		inst.mmstorage = foundmmstorage
		print("Existing storage found. Creating Link... ", inst.mmstorage)
	end
	
	inst.mmstorage.Transform:SetPosition(inst:GetPosition():Get())
	inst.mmstorage:SetFollowTarget(inst, "swap_storage", 0, 0, 0)
end

local function FillStorageWithSurpriseMob(inst, mob)
	local mms = inst.mmstorage
	local chestmobtable = mms.components.mnzmachines.surpriseinchest

	if chestmobtable[mob] == nil then
		chestmobtable[mob] = 1
	elseif chestmobtable[mob] < 3 then
		chestmobtable[mob] = chestmobtable[mob] + 1
	end
end

local function StopDigging(inst)
	if inst.diggingtask ~= nil then
		inst.diggingtask:Cancel()
		inst.diggingtask = nil
	end
end

local function DiggingJob(inst)
	print("*********** I start the digging action ***********")
	
	if math.random() < 0.7 then -- make the success odd configurable later
		print("I digged successfully! :-)")
		
		local tiletype = TheWorld.Map:GetTileAtPoint(inst.Transform:GetWorldPosition())
		print("Tile Type is ", tiletype)

		local tier_draw = math.random()
		local tier_loot
		
		if tier_draw <= MMLOOTTABLE["BIOME_"..tiletype].TIERONE.tierthreshold then
			tier_loot = "TIERONE"
		elseif tier_draw > MMLOOTTABLE["BIOME_"..tiletype].TIERONE.tierthreshold and tier_draw <= MMLOOTTABLE["BIOME_"..tiletype].TIERTWO.tierthreshold then
			tier_loot = "TIERTWO"	
		else
			tier_loot = "TIERTHREE"		
		end
		
		print("Random Tier Drawing = ", tier_draw, " <-> ", tier_loot)
		
		for n, m in pairs(MMLOOTTABLE["BIOME_"..tiletype][tier_loot]) do
			if n ~= "tierthreshold" then
				local current_minodd = 0
				for k, v in pairs(MMLOOTTABLE["BIOME_"..tiletype][tier_loot]) do
					if k ~= "tierthreshold" and v > current_minodd and v < m then
						current_minodd = v
					end
				end
				
				print("Probability to dig ", n, " = ", (m - current_minodd)  * 100, "%")
			end
		end
		
		local item_draw = math.random()
		local closest_th = 2
		local item_to_dig = nil
		for k, v in pairs(MMLOOTTABLE["BIOME_"..tiletype][tier_loot]) do
			if k ~= "tierthreshold" and v < closest_th and v > item_draw then
				closest_th = v
				item_to_dig = k
			end
		end
		
		print("---> Item to Dig  ", item_to_dig or "NOTHING!", " (draw = ", item_draw, ")")
		
		local mms = inst.mmstorage
		
		if item_to_dig then
			print("------> Storage = ", inst.mmstorage, "(found the container component : ", inst.mmstorage.components.container, ")")
			-- inst.components.lootdropper:SpawnLootPrefab(item_to_dig)
			local item_to_store = SpawnPrefab(item_to_dig)
			local storeincontainer = mms.components.container:GiveItem(item_to_store, nil, nil, false)
		end
		
		local chestmob_draw = math.random()
		if mms.components.mnzmachines.surpriseinchest and chestmob_draw < TUNING.CHESTMOBSODDS then
			closest_th = 2
			local mob_to_store = nil
			for k, v in pairs(MMLOOTTABLE["BIOME_"..tiletype]["CHESTMOBS"]) do
				if v < closest_th and v > chestmob_draw/TUNING.CHESTMOBSODDS then -- the division by the odd is to bring it back to a base of 1
					closest_th = v
					mob_to_store = k
				end
			end
			print("I brought a surprise with the loot : ", mob_to_store)
			FillStorageWithSurpriseMob(inst, mob_to_store)
		end
	else
		if TheWorld.state.season == "summer" then
			if math.random() < 0.3 then
				print("Failed Digging Task : Machine Jammed!!")
				inst.components.mnzmachines.jammed = true 
			end
		else
			if math.random() < 0.15 then
				print("Failed Digging Task : Machine Jammed!!")
				inst.components.mnzmachines.jammed = true 
			end
		end
	end
	
	print("I performed my digging action!")
end

local function InitializeDigging(inst)
	if inst.mmstorage == nil then
		inst:DoTaskInTime(1, GetMMStorage)
	end
	
	if inst.diggingtask == nil then
		if TheWorld.state.season == "winter" then
			inst.diggingtask = inst:DoPeriodicTask(7, DiggingJob) -- adjust the periodicity later with TUNING.SEG_TIME (make it configurable anyway)
		else
			inst.diggingtask = inst:DoPeriodicTask(5, DiggingJob) -- adjust the periodicity later with TUNING.SEG_TIME (make it configurable anyway)
		end
	end
end

local function TurnOff(inst, instant)
	inst.on = false

	StopDigging(inst)
	
	inst.components.fueled:StopConsuming()
	
	-- inst.sg:GoToState("turn_off")
end

local function TurnOn(inst, instant)
	inst.on = true
	
	if not inst:HasTag("jammed") then
		InitializeDigging(inst)
	end
	
	inst.components.fueled:StartConsuming()
	
	-- inst.sg:GoToState("turn_on")
end

local function CheckForEscapeMobs(inst)	
	print("========= Check for a Mob Escape ============")
	local escmob_draw = math.random()
	
	if escmob_draw < TUNING.ESCMOBSODDS then
		print("A Mob Escaped!")
		local tiletype = TheWorld.Map:GetTileAtPoint(inst.Transform:GetWorldPosition())
		local closest_th = 2
		local mob_to_esc
		for k, v in pairs(MMLOOTTABLE["BIOME_"..tiletype]["ESCAPEMOBS"]) do
			if v < closest_th and v > escmob_draw/TUNING.ESCMOBSODDS then
				closest_th = v
				mob_to_esc = k
			end
		end
		print("A Mob Escaped! : ", mob_to_esc)
		local escmob = SpawnPrefab(mob_to_esc)
		escmob.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local function onhammered(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	if inst.mmstorage ~= nil then
		inst.mmstorage:Remove()
		inst.mmstorage = nil
	end
	
	inst:Remove()
end

local function OnSeasonChange(inst, data)
	StopDigging(inst)
	inst:DoTaskInTime(0.5, function()
								InitializeDigging(inst)
							end
					)
end

local function onsaveMM(inst, data)
-- placeholder
end

local function onloadMM(inst, data)
-- placeholder
end

local function OnFuelEmpty(inst)
    inst.components.machine:TurnOff()
end

local function OnAddFuel(inst)
    if inst.on == false then
        inst.components.machine:TurnOn()
    end
end

-- local function OnFuelSectionChange(new, old, inst)
    -- if inst._fuellevel ~= new then
        -- inst._fuellevel = new
        -- inst.AnimState:OverrideSymbol("swap_meter", "firefighter_meter", new)
    -- end
-- end

local function miningmachinefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 1)
	
	-- inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("miningmachine")
	inst.AnimState:SetBuild("miningmachine")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:OverrideSymbol("swap_storage", "", "")
	
	inst:AddTag("structure")
	inst:AddTag("mining")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("fueled")
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.accepting = true
	inst.components.fueled.ontakefuelfn = OnAddFuel
	inst.components.fueled.fueltype = FUELTYPE.BURNABLE
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
	inst.components.fueled.bonusmult = 3.5
	inst.components.fueled:SetSections(10)
	-- inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	inst.components.fueled.maxfuel = TUNING.TOTAL_DAY_TIME*5
    inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME*5)
	inst.components.fueled.OnSave = OnSaveFueled
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	-- inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:AddComponent("mnzmachines")
	inst.leaktask = inst:DoPeriodicTask(TUNING.TOTAL_DAY_TIME/4, CheckForEscapeMobs) -- A mob can escape 4 times per day. This value should be tuned (?)
	
	inst:ListenForEvent("seasonChange", OnSeasonChange)
	
	inst.components.machine:TurnOn()
	
	inst.OnSave = onsaveMM
	inst.OnLoad = onloadMM
	
	MakeHauntableLaunch(inst)
	
	return inst
end

---------------------------------------------------------------------STORAGE---------------------------------------------------------

local function SetFollowTarget(inst, target, follow_symbol, follow_x, follow_y, follow_z)
	inst.followtarget = target
	if inst.followtarget ~= nil then
		inst.Follower:FollowSymbol(target.GUID, follow_symbol, follow_x, follow_y, follow_z)
		inst.savedfollowtarget = target
	elseif inst.savedfollowtarget ~= nil then
		inst:Remove()
	end
end

local containers = require "containers"
local prev_widgetsetup=containers.widgetsetup

local xmin, xmax, ymin, ymax

if TUNING.MMSTORAGESIZE == "ui_mms_2x2" then
	xmin = 0.5
	xmax = 1.5
	ymin = 0.5
	ymax = 1.5
elseif TUNING.MMSTORAGESIZE == "ui_mms_2x3" then
	xmin = 0.5
	xmax = 1.5
	ymin = 0
	ymax = 2
elseif TUNING.MMSTORAGESIZE == "ui_mms_4x3" then
	xmin = -0.5
	xmax = 2.5
	ymin = 0
	ymax = 2
elseif TUNING.MMSTORAGESIZE == "ui_mms_4x4" then
	xmin = -0.5
	xmax = 2.5
	ymin = -0.5
	ymax = 2.5
else -- if the config is overriden to an invalid value through modoverride.lua, at least it will load the 3x3 config and won't crash
	xmin = 0
	xmax = 2
	ymin = 0
	ymax = 2
end

local MMSwidgetparams =
	{
		widget =
		{
			slotpos = {},
			animbank = TUNING.MMSTORAGESIZE,
			animbuild = "ui_mms",
			pos = Vector3(0, 0, 0),
		},
		issidewidget = false,
		type = "chest",
	}
	
for y = ymax, ymin, -1 do
    for x = xmin, xmax do
        table.insert(MMSwidgetparams.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, MMSwidgetparams.widget.slotpos ~= nil and #MMSwidgetparams.widget.slotpos or 0)

local function mywidgetsetup(container, prefab, data)
    local t = data or params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    end
end

function MMSwidgetparams.itemtestfn(container, item, slot) 
	local owner = item.components.inventoryitem and item.components.inventoryitem.owner
	if owner ~= nil and owner:HasTag("player") then
		return false -- We don't want the player to be able to put stuffs in this storage do we? We just want them to be able to collect what's in.
	else
		return true
	end
end

local function OnWidgetUpdate(inst)
	containers.widgetsetup = mywidgetsetup
    inst.replica.container:WidgetSetup(inst.prefab, MMSwidgetparams)
	containers.widgetsetup = prev_widgetsetup
end

local function OnOpenMMS(inst)
	print("I call the OnOpenMMS for ", inst)
	print("-> Found mnzmachines component : ", inst.components.mnzmachines)
	local surprisetable = inst.components.mnzmachines and inst.components.mnzmachines.surpriseinchest
	print("-> surpriseinchest exists : ", surprisetable, "and is not empty ", surprisetable ~= nil)
	
	for k, v in pairs(surprisetable) do
		print(k, " / ", v)
	end
	
	if inst.components.mnzmachines and surprisetable then
		for k, v in pairs(surprisetable) do
			for n = 1, v, 1 do
				inst:DoTaskInTime(0.5, function()
											local surprisemob = SpawnPrefab(k)
											surprisemob.Transform:SetPosition(inst.Transform:GetWorldPosition())
										end
								)
			end
		end
		
		inst.components.mnzmachines.surpriseinchest = {}
	end
end

local function miningmachine_storagefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	inst.entity:AddNetwork()

	-- inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("storage")
	inst.AnimState:SetBuild("miningmachine")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("storage")
	
	inst._widgetupdate = net_bool(inst.GUID, "_widgetupdate", "onwidgetupdate")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
	inst:ListenForEvent("onwidgetupdate", OnWidgetUpdate)
		return inst
	end

	inst:AddComponent("container")
	containers.widgetsetup = mywidgetsetup
    inst.components.container:WidgetSetup(inst.prefab, MMSwidgetparams)
	containers.widgetsetup = prev_widgetsetup
	inst._widgetupdate:set(true)
	inst.components.container.onopenfn = OnOpenMMS
	
	inst:AddComponent("mnzmachines")
	
	inst.SetFollowTarget = SetFollowTarget
	
	return inst
end

------------------------------------------------------------------------------KIT----------------------------------------------------

local function OnDeployMM(inst, pt, deployer)
	inst.Physics:Teleport(pt:Get())
	local deployedkit = SpawnPrefab("miningmachinekit")
	deployedkit.Physics:SetCollides(false)
	deployedkit.Transform:SetPosition(inst.Transform:GetWorldPosition())
	deployedkit.Physics:SetCollides(true)
	inst:Remove()
end

local validtiles = { GROUND.ROCKY , GROUND.SAVANNA , GROUND.GRASS , GROUND.FOREST , GROUND.MARSH , GROUND.CARPET , GROUND.DECIDUOUS , GROUND.DESERT_DIRT}

local function CanDeployMM(self, pt, mouseover)
	local candeploybase = TheWorld.Map:CanDeployAtPoint(pt, self.inst)
	
	local deploytile = TheWorld.Map:GetTileAtPoint(pt:Get())
	local groundcheck = false
	
	for k, v in pairs(validtiles) do
		if deploytile == v then
			groundcheck = true
			break
		end
	end
	
	local minspacingcheck = true
	local nearbyents = TheSim:FindEntities(pt.x, pt.y, pt.z, 8, { "MnZmachines" , "structure" })
	for k, v in pairs(nearbyents) do
		if v:IsValid() then
			minspacingcheck = false
			break
		end
	end
	
	return (candeploybase and groundcheck and minspacingcheck)
end

local function OnHostChangeCanDeploy(inst)
	if inst._hostcandeploy:value() ~= inst._clientcandeploy then	
		inst._clientcandeploy = inst._hostcandeploy:value()		
		inst.replica.inventoryitem.CanDeploy = CanDeployMM
	end
end

local function miningmachinekit_itemfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
     
    inst.AnimState:SetBank("kit")
    inst.AnimState:SetBuild("miningmachine")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetScale(0.4,0.4,1)
 
	inst:AddTag("kit") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	
 	inst._hostcandeploy = net_bool(inst.GUID, "_hostcandeploy", "onhostchangecandeploy")
	
 --The following section is suitable for a DST compatible prefab.
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then	
		inst._clientcandeploy = nil
		inst:ListenForEvent("onhostchangecandeploy", OnHostChangeCanDeploy)
        return inst
    end
	
----------------------------------------------------------------

    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "miningmachinekit"
    inst.components.inventoryitem.atlasname = "images/inventory/miningmachinekit.xml"

    inst:AddComponent("deployable")
	
	inst.components.deployable.CanDeploy = CanDeployMM
	inst._hostcandeploy:set(true)
	inst.components.deployable.ondeploy = OnDeployMM

	inst:AddComponent("mnzmachines")
	
    MakeHauntableLaunch(inst)

	return inst
end

local function miningmachinekitfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
     
    inst.AnimState:SetBank("kit")
    inst.AnimState:SetBuild("miningmachine")
    inst.AnimState:PlayAnimation("idle")
 
	inst:AddTag("kit") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("structure")
	
 	inst._hostcandeploy = net_bool(inst.GUID, "_hostcandeploy", "onhostchangecandeploy")
	
 --The following section is suitable for a DST compatible prefab.
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then	
		inst._clientcandeploy = nil
		inst:ListenForEvent("onhostchangecandeploy", OnHostChangeCanDeploy)
        return inst
    end
	
----------------------------------------------------------------

    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	-- inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:AddComponent("mnzmachines")
	
    MakeHauntableLaunch(inst)

	return inst
end

return  Prefab("common/machines/miningmachine", miningmachinefn, assets, prefabs),
		Prefab("common/machines/miningmachine_storage", miningmachine_storagefn, assets, prefabs),
		Prefab("common/machines/miningmachinekit", miningmachinekitfn, assets, prefabs),
		Prefab("common/machines/miningmachinekit_item", miningmachinekit_itemfn, assets, prefabs),
		MakePlacer("common/machines/miningmachinekit_item_placer", "miningmachine", "miningmachine", "idle")