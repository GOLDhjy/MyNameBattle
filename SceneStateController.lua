require "StartSceneState"
require "BattleSceneState"

SceneStateController = {}
SceneStateController.CurrentState = nil
SceneStateController.States = {}
function SceneStateController:New( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self
	o.CurrentState = nil
	o.States = {}
	return o
end
function SceneStateController:AddState( state )
	if state == nil then
		print( "传入状态值为空" )
		return
	end
	if self.States[state.Name] == true then
		print( state.Name.."已经存在" )
		return
	end
	if self.States[state.Name] == nil then
		self.States[state.Name] = true
		self.CurrentState = state
		print( "添加状态"..state.Name.."成功" )
		return
	end
end
function SceneStateController:DellteState( state )
	if state == nil then
		print( "传入状态值为空,删除是失败" )
		return
	end
	if self.States[state.Name] == true then
		self.States[state.Name] = nil
		print( "删除"..state.Name.."成功" )
		return
	end
end
function SceneStateController:ChangeState( state )
	if state == nil then
		print( "传入状态值为空,修改失败" )
		return
	end
	if self.States[state.Name] == true then
		self.CurrentState = state
		--print( "修改成功" )
		return
	end
	print( "修改失败" )
end