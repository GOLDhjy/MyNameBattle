require "Tab"


SkillSystem = {}

Tab:Load( SkillSystem , "MySkill.tab")

SkillSystem.IsSeed = false

function SkillSystem:GetRandomSkill( value )
	if SkillSystem.IsSeed == false then
		if value ~= nil then
			math.randomseed( value )
		else
			math.randomseed( os.time() )
		end
		SkillSystem.IsSeed = true
	end
	return SkillSystem[ math.random(1,#SkillSystem)]
end



function SkillSystem:AddSkill( SkillName , Attack , AttackDep , BeAttackDep)
	local Skill = {} 
	if SkillName ~= nil then
		Skill.SkillName = tostring( SkillName ) 
	else
		print( "添加SkillName为空" )
		Skill.SkillName = ""
	end
	if Attack ~= nil then
		Skill.Attack = Attack
	else
		print( "添加Attack目标为空" )
		Skill.Attack = ""
	end
	if AttackDep ~= nil then
		Skill.AttackDep = AttackDep
	else
		print( "添加AttackDep为空" )
		Skill.AttackDep = ""
	end
	if BeAttackDep ~= nil then
		Skill.BeAttackDep = BeAttackDep
	else
		print( "添加BeAttackDep为空" )
		Skill.BeAttackDep = ""
	end
	SkillSystem[#SkillSystem + 1] = Skill
end

function SkillSystem:DeleteSkillWithName( SkillName )
	if SkillName == nil then
		print( "输入Buff名字为空，删除Buff失败" )
		return
	end
	for i , skill in ipairs(SkillSystem) do
		if skill.Name == tostring( SkillName ) then
		 	SkillSystem[i] = nil
		 	print( "删除"..SkillName.."成功" )
		 	return
		end 
	end
	print( "删除"..SkillName.."失败" )
end

function SkillSystem:ModifySkillAttackDep( SkillName ,  AttackDep)
	if SkillName == nil then
		print( "传入Buff名为空,修改Buff失败" )
		return
	elseif AttackDep == nil then
		print( "传入Target为空，修改Buff失败" )
		return
	else
		for i , skill in ipairs( SkillSystem ) do
			if skill.Name == SkillName then
				skill.AttackDep = tostring(AttackDep)
				print( "修改"..SkillName..AttackDep.."成功" )
				return
			end
		end
	end
	print( "修改"..SkillName..AttackDep.."失败" )
end

function SkillSystem:ModifySkillAttack( SkillName ,  Attack)
	if SkillName == nil then
		print( "传入Buff名为空,修改Buff失败" )
		return
	elseif Attack == nil then
		print( "传入Target为空，修改Buff失败" )
		return
	else
		for i , skill in ipairs( SkillSystem ) do
			if skill.Name == SkillName then
				skill.Attack = tostring(Attack)
				print( "修改"..SkillName..Attack.."成功" )
				return
			end
		end
	end
	print( "修改"..SkillName..Attack.."失败" )
end

function SkillSystem:SaveSkillTable(  )
	
end