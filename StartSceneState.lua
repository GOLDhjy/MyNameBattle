require "SceneState"

StartSceneState = SceneState:New()
StartSceneState.Name = "StartScene"

function StartSceneState:New( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self
	return o
end
function StartSceneState:Update(PlayerA,PlayerB,SceneFSM)
	print( "请输入A的名字：" )
	PlayerA.Name = io.read()
	print( "请输入B的名字：" )
	PlayerB.Name = io.read()

	PlayerA:Init()
	PlayerB:Init()
	
	StartSceneState:Exit( SceneFSM )
	
	--return PlayerA,PlayerB
end 
function StartSceneState:Exit( Controller )
	--Controller:ChangeState( BattleSceneState:New() )
	--BattleSceneState = BattleSceneState or require "BattleSceneState"
	Controller:ChangeState(BattleSceneState:New())
end
