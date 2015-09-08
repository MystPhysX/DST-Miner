local function onjammed(self, jammed)
	if jammed and self.inst.components.machine then
		if not self.inst:HasTag("jammed") then
			self.inst:AddTag("jammed")
		end
		
		if self.inst.components.machine then
			self.inst.components.machine:TurnOff()
			self.inst.AnimState:PlayAnimation("jammed", true)
		end
		
		if not self.inst:HasTag("cooldown") then
			self.inst:DoTaskInTime(0.6, function () -- to prevent a DoTaskInTime of the TunOff function to interfere after 0.5 seconds, I execute it after 0.6 seconds
										self.inst:AddTag("cooldown") -- artificially set it in cooldown so player cannot interact with the machine anymore (see componentaction for machine for more info)
									end
							)
		end
	elseif not jammed and self.inst.components.machine then
		if self.inst:HasTag("jammed") then
			self.inst:RemoveTag("jammed")
		end
		if self.inst:HasTag("cooldown") then
			self.inst:RemoveTag("cooldown")
		end
		
		if self.inst.components.machine then
			self.inst.components.machine:TurnOn()
		end
	end
end

local Mnzmachines = Class(function(self, inst)
    self.inst = inst

	self.jammed = false
	self.surpriseinchest = {}
	self.lastescapemob = nil
	
    self.inst:AddTag("MnZmachines")
end,
nil,
{
	jammed = onjammed
})

function Mnzmachines:TakeSpecialFuelItem(item)
	if self.inst.components.fueled then
		local oldsection = self.inst.components.fueled:GetCurrentSection()

		local mole_draw = math.random()
		
		if mole_draw < 0.5 then
			self.inst.components.fueled:DoDelta(2*TUNING.TOTAL_DAY_TIME)
			print("Successfully added a mole for fuel!")
		elseif mole_draw > 0.9 then
			self.jammed = not self.jammed
			print("Unwilling mole subject : Machine State Inverted!")
		else
			print("Added a mole for fuel was unsuccessful")
		end
			
		item:Remove()

		return true
	end
end

function Mnzmachines:OnRemoveFromEntity()
	self.surpriseinchest = nil
end

function Mnzmachines:OnSave()
	if self.jammed or self.surpriseinchest then
		return { jammed = self.jammed or nil , surpriseinchest = self.surpriseinchest or nil }
	end
end

function Mnzmachines:OnLoad(data)
    if data.jammed then
        self.inst:DoTaskInTime(0.6, function() -- To prevent unwanted interaction with the TunOff function of the machine component
										self.jammed = data.jammed
									end
							)
    end
	
	if data.surpriseinchest then
		self.surpriseinchest = data.surpriseinchest
	end
end

return Mnzmachines