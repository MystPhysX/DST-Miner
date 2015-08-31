local assets=
{
    Asset("ANIM", "anim/miningmachine.zip"),
	
	Asset("ANIM", "anim/ui_mms.zip"),
}

prefabs = {
}

-----------------------------------------------------------THE MACHINE ITSELF-----------------------------------------------------

local function miningmachinefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

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
	
	-- inst:AddComponent("machine")
	-- inst.components.machine.turnonfn = TurnOn
	-- inst.components.machine.turnofffn = TurnOff
	-- inst.components.machine.cooldowntime = 0.5
	
	inst.mmstorage = SpawnPrefab("miningmachine_storage")
	inst.mmstorage.Transform:SetPosition(inst:GetPosition():Get())
	inst.mmstorage:SetFollowTarget(inst, "swap_storage", 0, 0, 0)
	
	-- inst:AddComponent("fueled")
	-- inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	-- inst.components.fueled.accepting = true
-- --    inst.components.fueled.ontakefuelfn = OnAddFuel
	-- inst.components.fueled.fueltype = FUELTYPE.BURNABLE
	-- inst.components.fueled.bonusmult = placeholder
	-- inst.components.fueled.CanAcceptFuelItem = placeholder
	-- inst.components.fueled:SetSections(placeholder)
	-- inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	-- inst.components.fueled.maxfuel = placeholder
	-- inst.components.fueled.TakeFuelItem = placeholder
	-- inst:DoTaskInTime(0, function()
	--							dostuffs
						-- end
					-- )
	-- inst.components.fueled.OnSave = OnSaveFueled
	
	-- inst:AddComponent("lootdropper")
	
	-- inst:AddComponent("workable")
	-- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	-- inst.components.workable:SetWorkLeft(5)
	-- inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	-- inst:ListenForEvent("onbuilt", onbuilt)
	
	-- inst.OnSave = onsave 
	-- inst.OnLoad = onload
	
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
<<<<<<< HEAD
	
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

local function OnWidgetUpdate(inst)
	containers.widgetsetup = mywidgetsetup
    inst.replica.container:WidgetSetup(inst.prefab, MMSwidgetparams)
	containers.widgetsetup = prev_widgetsetup
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
=======
	
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

-- local function OpenMMS(self, doer)
	-- if self.opener == nil and doer ~= nil then	
		-- self.inst:StartUpdatingComponent(self)

		-- local inventory = doer.components.inventory
		-- if inventory ~= nil then
			-- for k, v in pairs(inventory.opencontainers) do
				-- if k.prefab == self.inst.prefab or k.components.container.type == self.type then
					-- k.components.container:Close()
				-- end
			-- end

			-- inventory.opencontainers[self.inst] = true
		-- end

		-- self.opener = doer

		-- if doer.HUD ~= nil then
			-- local playercontainers = doer.HUD.controls.containers
			-- local quiverwidget = nil
					
			-- local hudscaleadjust = Profile:GetHUDSize()*2
			-- local qs_pos = INVINFO.EQUIPSLOT_quiver:GetWorldPosition()
		
			-- doer.HUD:OpenContainer(self.inst, self:IsSideWidget())
			-- TheFocalPoint.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open", "open")
			
			-- if playercontainers then
				-- for k, v in pairs(playercontainers) do
					-- if v.container == self.inst then
						-- quiverwidget = v
					-- end
				-- end
			-- end
			
			-- if quiverwidget ~= nil then
				-- if quiverwidget.QuiverHasAnchor == nil then
					-- quiverwidget.QuiverHasAnchor = true
					
					-- quiverwidget:SetVAnchor(ANCHOR_BOTTOM)
					-- quiverwidget:SetHAnchor(ANCHOR_LEFT)
				-- end
				
				-- quiverwidget:UpdatePosition(qs_pos.x, (qs_pos.y+60+hudscaleadjust))			
			-- end
		-- end
		
		-- self.inst:PushEvent("onopen", { doer = doer })

		-- if self.onopenfn ~= nil then
			-- self.onopenfn(self.inst)
		-- end
	-- end
-- end

local function OnWidgetUpdate(inst)
    -- if inst._widgetupdate:value() ~= inst._clientwidgetupdate then
        -- inst._clientwidgetupdate = inst._widgetupdate:value()
		containers.widgetsetup = mywidgetsetup
        inst.replica.container:WidgetSetup(inst.prefab, MMSwidgetparams)
		containers.widgetsetup = prev_widgetsetup
		-- inst.replica.container.Open = OpenQuiverClient
    -- end
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
	-- inst._clientwidgetupdate = false
>>>>>>> origin/zupalex-test-branch
	inst:ListenForEvent("onwidgetupdate", OnWidgetUpdate)
		return inst
	end

	inst:AddComponent("container")
	containers.widgetsetup = mywidgetsetup
    inst.components.container:WidgetSetup(inst.prefab, MMSwidgetparams)
	containers.widgetsetup = prev_widgetsetup
	inst._widgetupdate:set(true)
<<<<<<< HEAD
=======
	-- inst.components.container.Open = OpenMMStorage
>>>>>>> origin/zupalex-test-branch
	
	inst.SetFollowTarget = SetFollowTarget
	
	return inst
end

return  Prefab("common/machines/miningmachine", miningmachinefn, assets, prefabs),
		Prefab("common/machines/miningmachine_storage", miningmachine_storagefn, assets, prefabs)