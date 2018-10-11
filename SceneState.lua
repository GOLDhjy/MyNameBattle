SceneState = {}

function SceneState:New( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self
	return o;
end