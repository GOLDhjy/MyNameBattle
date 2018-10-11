
AIState = {}
AIState.Target = nil;
--AIState.MyCharacterAI = CharacterAI:New() 	--角色状态
function AIState:New( o )
	o = o or {}
	setmetatable( o , self  )
	self.__index = self;
	return o;
end
function AIState:SetCharacterAI( mycharacterAI )
	self.MyCharacterAI = mycharacterAI;
end
function AIState:SetTarget( enemy )
	self.Target = enemy;
end
function AIState:RemoveTarget(  )
	self.Target = nil;
end
function AIState:Init()
end
function AIState:Update() 	--主要的状态逻辑
end
function AIState:Exit()
end
return AIState