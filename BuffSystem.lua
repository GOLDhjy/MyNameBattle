require "Tab"

BuffSystem = {}


BuffSystem.IsSeed = false

function BuffSystem:Init(  )
	Tab:Load( BuffSystem , "Buff.tab")
end

function BuffSystem:GetRandomSkill( value )
	if BuffSystem.IsSeed == false then
		if value ~= nil then
			math.randomseed( value )
		else
			math.randomseed( os.time() )
		end
		BuffSystem.IsSeed = true
	end

	return BuffSystem[ math.random(1,#BuffSystem)]
end

function BuffSystem:AddBuff( BuffName , Target , Value , BuffDep)
	local Buff = {} 
	if BuffName ~= nil then
		Buff.BuffName = tostring( BuffName ) 
	else
		print( "添加Buff名为空" )
		Buff.BuffName = ""
	end
	if Target ~= nil then
		Buff.Target = Target
	else
		print( "添加Buff目标为空" )
		Buff.Target = ""
	end
	if Value ~= nil then
		Buff.Value = Value
	else
		print( "添加Value为空" )
		Buff.Value = ""
	end
	if BuffDep ~= nil then
		Buff.BuffDep = BuffDep
	else
		print( "添加BuffDep为空" )
		Buff.BuffDep = ""
	end
	BuffSystem[#BuffSystem + 1] = Buff
end

function BuffSystem:DeleteBuffWithName( BuffName )
	if BuffName == nil then
		print( "输入Buff名字为空，删除Buff失败" )
		return
	end
	for i , buff in ipairs(BuffSystem) do
		if buff.Name == tostring( BuffName ) then
		 	BuffSystem[i] = nil
		 	print( "删除"..BuffName.."成功" )
		 	return
		end 
	end
	print( "删除"..BuffName.."失败" )
end

function BuffSystem:ModifyBuffTarget( BuffName ,  Target)
	if BuffName == nil then
		print( "传入Buff名为空,修改Buff失败" )
		return
	elseif Target == nil then
		print( "传入Target为空，修改Buff失败" )
		return
	else
		for i , buff in ipairs( BuffSystem ) do
			if buff.Name == BuffName then
				buff.Target = tostring(Target)
				print( "修改"..BuffName..Target.."成功" )
				return
			end
		end
	end
	print( "修改"..BuffName..Target.."失败" )
end

function BuffSystem:ModifyBuffValue( BuffName ,  Value)
	if BuffName == nil then
		print( "传入Buff名为空,修改Buff失败" )
		return
	elseif Value == nil then
		print( "传入Target为空，修改Buff失败" )
		return
	else
		for i , buff in ipairs( BuffSystem ) do
			if buff.Name == BuffName then
				buff.Value = tostring(Value)
				print( "修改"..BuffName..Value.."成功" )
				return
			end
		end
	end
	print( "修改"..BuffName..Value.."失败" )
end

function BuffSystem:SaveBuffTable(  )
	
end

BuffSystem:Init(  )