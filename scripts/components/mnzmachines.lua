local function onjammed(self, jammed)
	if jammed then
		if not self.inst:HasTag("jammed") then
			self.inst:AddTag("jammed")
		end
		if not self.inst:HasTag("cooldown") then
			self.inst:AddTag("cooldown") -- artificially set it in cooldown so player cannot interact with the machine anymore (see componentaction for machine for more info)
		end
	else
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

function Mnzmachines:OnRemoveFromEntity()
	self.surpriseinchest = nil
end

function Mnzmachines:OnSave()
	if self.jammed or (self.surpriseinchest and #self.surpriseinchest > 0) then
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
	
	if data.surpriseinchest and #data.surpriseinchest > 0 then
		self.surpriseinchest = data.surpriseinchest
	end
end

return Mnzmachines