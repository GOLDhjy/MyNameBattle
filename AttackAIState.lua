AIState = AIState or require "AIState"
require "SkillSystem"

AttackAIState = AIState:New()
AttackAIState.Name = "AttackAI"
function AttackAIState:New( o )
	o = o or {}
	setmetatable( o , self  )
	self.__index = self;
	return o;
end

AttackAIState.AttackTarget = nil

function AttackAIState:Init( oneself , enemy ) --执行状态里面的操作
	
	Skill = SkillSystem:GetRandomSkill()
	print( "角色【"..oneself.Name.."】发动"..Skill.SkillName.."攻击" )
	enemy.HP = enemy.HP - tonumber( Skill.Attack )
	oneself.Attack = tonumber( Skill.Attack )
	AttackAIState:Exit( oneself )
end

function AttackAIState:Update( oneself , enemy  )
	oneself:ChangeSkill()
	oneself:ChangeBuff()

	if oneself.Buff.Target == "Shooting" or oneself.Buff.Target == "HP" then
		print( "角色:【"..oneself.Name.."】 【"..oneself.Buff.BuffName.."】,->"..oneself.Buff.BuffDep )
		oneself:DoBuffWithPicture( oneself.Buff )
	end
	print( "角色:【"..oneself.Name.."】使出一招 【"..oneself.Skill.SkillName.."】,"..oneself.Skill.AttackDep )
	oneself:DoAttackWithPicture( oneself.Skill )
	--enemy.HP = enemy.HP - tonumber( Skill.Attack )
	--oneself.Attack = tonumber( Skill.Attack )
	oneself.Cat:DoAttackWithTarget( oneself )
	AttackAIState:Exit( oneself )
end

function AttackAIState:Exit( player ) --其实这里是退出状态的条件
	--Player =  Player or require "Player"
	player:SetRounds("Idle")
	--print( "Attack EXIT" )
end

return AttackAIState