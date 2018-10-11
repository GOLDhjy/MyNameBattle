require "MyEventSystem"
require "Tab"


AchievementSystem = {}
AchievementSystem.Title = {}
Tab:Load(AchievementSystem.Title, "Titletab.tab")


AchievementSystem.OnEvent = function ( Winner )
	if Winner == nil then
		print( "事件:更新玩家称号失败->玩家为空" )
		return
	end
	--print( "玩家："..Winner )
	AchievementSystem:AddPerson( Winner )
	AchievementSystem:AddBTN( Winner )
	AchievementSystem:UpdateTitle( Winner )
end

function AchievementSystem:SaveTitle(  )
	Tab:Write( AchievementSystem.Title, "Titletab.tab" )
end

function AchievementSystem:GetTitle( Name )
	--print( "GetTitle"..Name )
	AchievementSystem:AddPerson( Name )

	local IsExist = false
	local index = nil 
	for i , item in ipairs( AchievementSystem.Title ) do
		if AchievementSystem.Title[i].Name == Name then
			index = i
			IsExist = true
			break;
		end
	end
	if IsExist == true then
		AchievementSystem:UpdateTitle( Name )
		--print( "获得称号："..AchievementSystem.Title[index].Title )
		return AchievementSystem.Title[index].Title
	else
		
		print( "姓名对应称号不存在" )
		return "无"
	end
end

function AchievementSystem:AddPerson( Name )
	--print( "添加"..Name )
	local IsExist = false
	--local index = nil 
	for i , item in ipairs( AchievementSystem.Title ) do
		if AchievementSystem.Title[i].Name == Name then
			IsExist = true
			--index = i
			break;
		end
	end
	if IsExist == false then --新建一个表
		local t = {}
		t.Name = Name
		t.BTN = 0
		t.Title = "无"
		table.insert( AchievementSystem.Title, #AchievementSystem.Title + 1 , t )
	end
end

function AchievementSystem:AddBTN( Name )
	--print( "AddBTN:"..Name )
	local index = nil 
	local IsExist = false
	for i , item in ipairs( AchievementSystem.Title ) do
		if AchievementSystem.Title[i].Name == Name then
			IsExist = true
			index = i
			break;
		end
	end
	if IsExist == false then
		print( "不存在这个人，加1失败," )
		return
	end
	if AchievementSystem.Title[index].BTN == nil then
		AchievementSystem.Title[index].BTN = 0
	end
	AchievementSystem.Title[index].BTN = AchievementSystem.Title[index].BTN + 1
	--print( "BTN="..AchievementSystem.Title[index].BTN )
end

function AchievementSystem:UpdateTitle( Name ) --这里暂时没用配置表，先将就用着
	local index = nil 
	local IsExist = false
	for i , item in ipairs( AchievementSystem.Title ) do
		if AchievementSystem.Title[i].Name == Name then
			index = i
			IsExist = true
			break;
		end
	end
	if IsExist == false then
		print( "不存在这个人，更新称号失败" )
		return
	end
	if AchievementSystem.Title[index].Title == nil then
		AchievementSystem.Title[index].Title = "无"
		print( "获得称号：无" )
	end
	if tonumber( AchievementSystem.Title[index].BTN ) >= 1 and tonumber(AchievementSystem.Title[index].BTN) <3 then
		AchievementSystem.Title[index].Title = "初入江湖"
		print( "获得称号：初入江湖" )
	elseif tonumber( AchievementSystem.Title[index].BTN ) >= 3 and tonumber( AchievementSystem.Title[index].BTN ) < 6 then
			AchievementSystem.Title[index].Title = "初窥门径"
			print( "获得称号：初窥门径" )
	elseif tonumber( AchievementSystem.Title[index].BTN ) >= 6 and tonumber( AchievementSystem.Title[index].BTN ) < 9  then
			AchievementSystem.Title[index].Title = "久经江湖"
			print( "获得称号：久经江湖" )
	elseif tonumber( AchievementSystem.Title[index].BTN) >= 9 and tonumber( AchievementSystem.Title[index].BTN ) < 12  then
			AchievementSystem.Title[index].Title = "杀人如麻"
			print( "获得称号：杀人如麻" )
	elseif tonumber( AchievementSystem.Title[index].BTN ) >= 12   then
			AchievementSystem.Title[index].Title = "名慑天下"
			print( "获得称号：名慑天下" )
	else
		AchievementSystem.Title[index].Title = "无"
		print( "获得称号：无" )
		return
	end
end


MyEventSystem:RegisterEvent( "UpdateTitleWithBTN" , AchievementSystem.OnEvent )


--[[MyEventSystem:DoEvent( "UpdateTitle" , "hjy")
print( AchievementSystem:GetTitle( "hjy" ) )
MyEventSystem:DoEvent( "UpdateTitle" , "hjy")
MyEventSystem:DoEvent( "UpdateTitle" , "hjy")
MyEventSystem:DoEvent( "UpdateTitle" , "hjy")
print(AchievementSystem:GetTitle( "hjy" ))
MyEventSystem:DoEvent( "UpdateTitle" , "lsx")
MyEventSystem:DoEvent( "UpdateTitle" , "lsx")

for i , record in ipairs( AchievementSystem.Title ) do
	for i , item in pairs( AchievementSystem.Title[i] ) do
		print( i..":"..item )
	end
end

AchievementSystem:SaveTitle(  )]]--