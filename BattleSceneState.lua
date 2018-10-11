require "SceneState"
require "ExitSceneState"
require "MyEventSystem"

BattleSceneState = SceneState:New()
BattleSceneState.Name = "BattleScene"
function BattleSceneState:New( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self
	return o
end
function BattleSceneState:Update( PlayerA , PlayerB , SceneFSM )
	
	BattleSceneState:UpdatePlayer( PlayerA , PlayerB )
	BattleSceneState:sleep(2)
	BattleSceneState:CheckConvertCondition( PlayerA , PlayerB , SceneFSM )
end

function BattleSceneState:Exit( Controller , winner )
	print( "__________________________KO__________________________" )
	print( "【"..winner.Name.."】 WIN" )

	MyEventSystem:DoEvent( "UpdateTitleWithBTN" , winner.Name )

	Controller:ChangeState( ExitSceneState:New() )
end

function BattleSceneState:ShowPlayerInfo( PlayerA , PlayerB )
	PlayerA:ShowPlayerInfo()
	PlayerB:ShowPlayerInfo()
end

function BattleSceneState:UpdatePlayer( PlayerA , PlayerB )
	if PlayerA.fsm.CurrentState.Name == "IdleAI" and PlayerB.fsm.CurrentState.Name == "IdleAI" then
		PlayerA:SetRounds( "Attack" )
	--[[elseif PlayerA.fsm.CurrentState.Name == "IdleAI" and PlayerB.fsm.CurrentState.Name == "AttackAI" then
		PlayerA:SetRounds( "Attack" )
		PlayerB:SetRounds( "Idle" )
	elseif PlayerB.fsm.CurrentState.Name == "IdleAI" and PlayerA.fsm.CurrentState.Name == "AttackAI" then
		PlayerB:SetRounds( "Attack" )
		PlayerA:SetRounds( "Idle" )]]--
	end

	BattleSceneState:ShowPlayerInfo( PlayerA , PlayerB )
	print(  )

	if PlayerA.fsm.CurrentState.Name == "AttackAI" then
		PlayerA:Update(PlayerB)
		PlayerB:Update(PlayerA)
	elseif PlayerB.fsm.CurrentState.Name == "AttackAI" then
		PlayerB:Update(PlayerA)
		PlayerA:Update(PlayerB)
	else
		print( "BattleSceneState:UpdatePlayer error for no AttackAI" )
	end

	print(  )
	--BattleSceneState:ShowPlayerInfo( PlayerA , PlayerB )

	PlayerA:ConvertToDefaultField()
	PlayerB:ConvertToDefaultField()
end

function BattleSceneState:CheckConvertCondition( PlayerA , PlayerB , SceneFSM )
	if PlayerA.HP <= 0 and PlayerB.HP > 0 then
		BattleSceneState:Exit( SceneFSM ,PlayerB )
	elseif PlayerA.HP > 0 and PlayerB.HP <= 0 then
		BattleSceneState:Exit( SceneFSM ,PlayerA )
	end
end

function BattleSceneState:sleep(n)
   local t0 = os.clock()
   while os.clock() - t0 <= n do end
end