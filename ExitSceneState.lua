require "AIState"
require "StartSceneState"
require "AchievementSystem"

ExitSceneState = SceneState:New()
ExitSceneState.Name = "ExitAI"

function ExitSceneState:New( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self
	return o
end

function ExitSceneState:Update( PlayerA , PlayerB , SceneFSM )

	ExitSceneState:CheckConvertCondition( PlayerA , PlayerB , SceneFSM )
end

function ExitSceneState:Exit( )
	AchievementSystem:SaveTitle(  ) --保存配置表
	os.exit( 0 )
end

function ExitSceneState:CheckConvertCondition( PlayerA , PlayerB , SceneFSM )
	print( "......................【游戏结束】......................" )
	print( "输入【1】重新开始 || || 输入【0】退出游戏" )
    local Input = io.read(  )

	if Input == "1" then
		SceneFSM:ChangeState( StartSceneState:New() )
	elseif Input == "0" then
		ExitSceneState:Exit()
	else

		print( "请输入合法输入" )
		ExitSceneState:CheckConvertCondition( PlayerA , PlayerB , SceneFSM )
	end
end