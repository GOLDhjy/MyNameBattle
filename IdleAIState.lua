AIState = AIState or require "AIState"


IdleAIState = AIState:New()
IdleAIState.Name = "IdleAI"

function IdleAIState:New( o )
	o = o or {}
	setmetatable( o , self  )
	self.__index = self;
	return o;
end

function IdleAIState:Init( oneself , enemy )
		print( oneself.Name..":受到攻击攻击,减少 "..enemy.Attack.." 伤害" )
		IdleAIState:Exit( oneself )
end
function IdleAIState:Update( oneself , enemy )
	oneself:ChangeBuff()
	print( "角色:【"..oneself.Name.."】使出【"..oneself.Buff.BuffName.."】,"..oneself.Buff.BuffDep )

	if oneself.IsDodge == true and enemy.IsShooting == false then
		print( "角色:【"..oneself.Name.."】发动 【"..oneself.Buff.BuffName.."】,->"..oneself.Buff.BuffDep )
		oneself:DoBuffWithPicture( oneself.Buff )
		--print( "角色:"..oneself.Name.."->"..enemy.Buff.BuffDep )
	elseif oneself.IsDodge == true and enemy.IsShooting == true then
		oneself:Piece()
		print( "你的矛打不破我的盾，下一回合吧！" )
	else
		local Damage = oneself:CalculateDamageToMe( enemy )
		oneself.HP = oneself.HP - Damage
		print( "角色:【"..oneself.Name.."】:受到攻击,"..enemy.Skill.BeAttackDep.." -->受到"..Damage.." 伤害" )
	end

	--print( "角色:"..oneself.Name.."发动 "..oneself.Skill.SkillName.."攻击".."  攻击力变为"..oneself.Attack )
	IdleAIState:Exit( oneself )
end
function IdleAIState:Exit( player )
	--Player =  Player or require "Player"
	player:SetRounds("Attack")
	--print( "Idle EXIT" )
end

return IdleAIState