require "Player"
require "SceneStateController"
require "StartSceneState"
require "BattleSceneState"

SceneFSM = SceneStateController:New()
PlayerA = Player:New()
PlayerB = Player:New()

function Start()
	CreateSceneState( SceneFSM )
	SceneFSM.CurrentState = StartSceneState:New()
end
function Update()
	round = 1
print( "__________________________游戏开始__________________________" )
	while true do
		SceneFSM.CurrentState:Update(PlayerA,PlayerB,SceneFSM)
		--SceneFSM.CurrentState:Exit(SceneFSM)
		print(  )
		if SceneFSM.CurrentState.Name == "StartScene" then
			
			round = 0
		elseif SceneFSM.CurrentState.Name == "BattleScene" then
			print( "__________________________回合【"..round.."】__________________________" )
		end
		
		print(  )
		round = round + 1
	end
	--主循环里设置角色轮次
end
function CreateSceneState( SceneFSM )
	SceneFSM:AddState( StartSceneState:New() )
	SceneFSM:AddState( BattleSceneState:New() )
	SceneFSM:AddState( ExitSceneState:New() )
end

Start()
Update()


