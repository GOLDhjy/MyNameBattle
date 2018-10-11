 require "Tab"

 FollowerCat = {}
 FollowerCat.CatList = {}
 Tab:Load(FollowerCat.CatList, "CatList.tab")
 FollowerCat.IsSeed = false

function FollowerCat:AddCat( CatName , Skill1 , Skill1Target, Skill1Value , Skill2 , Skill2Target , Skill2Value , UpTarget , UpValue )
	local IsExist = false
	for i , item in ipairs( FollowerCat.CatList ) do
		if item.CatName == CatName then
			IsExist = true
		end
	end
	if IsExist == false then
		local t = {}
		t.CatName = CatName
		t.Skill1 = Skill1
		t.Skill1Target = Skill1Target
		t.Skill1Value = Skill1Value
		t.Skill2 = Skill2
		t.Skill2Target = Skill2Target
		t.Skill2Value = Skill2Value
		t.UpTarget = UpTarget
		t.UpValue = UpValue
		table.insert( FollowerCat.CatList, #FollowerCat.CatList + 1, t )
	elseif IsExist == true then
		print( "该玩家已经存在" )
		return
	end
end

function FollowerCat:RemoveCat( CatName )
	local IsExist = false
	local index = nil
	for i , item in ipairs( FollowerCat.CatList ) do
		if item.CatName == CatName then
			IsExist = true
			index = i
			break
		end
	end
	if IsExist == false then
		print( "不存在该宠物，删除失败" )
		return
	elseif IsExist == true then
		table.remove( FollowerCat.CatList, index )
		print( "删除宠物成功" )
	end
end

function FollowerCat:New( Value )
	if FollowerCat.IsSeed == false then
		if value ~= nil then
			math.randomseed( value )
		else
			math.randomseed( os.time() )
		end
		FollowerCat.IsSeed = true
	end
	if #FollowerCat.CatList == 0 then
		print( "宠物列表为空，获取失败" )
		return
	end
	local t = FollowerCat.CatList[ math.random(1,#FollowerCat.CatList)]
	setmetatable( t, self )
	self.__index = self
	return t
end

function FollowerCat:SaveCatList(  )
	Tab:Write( FollowerCat.CatList, "CatList.tab" )
end

function FollowerCat:DoAttack(  )
	local number = math.random( 1, 10 )
	if number > 2 then
		print( "宠物:【"..self.CatName.."】选择沉默" )
		return
	elseif number == 1 then
		return self.Skill1 , self.Skill1Target, self.Skill1Value
	elseif number == 2 then
		return self.Skill2 , self.Skill2Target , self.Skill2Value
	end
end

function FollowerCat:DoAttackWithTarget( Player )
	Skill,SkillTarget,SkillValue = self:DoAttack(  )
	--print( Skill..SkillTarget..SkillValue )
	if Skill == nil then
		return
	else
		print( "宠物:【"..self.CatName.."】"..Skill..Player.Name..SkillValue )
		Player[SkillTarget] = Player[SkillTarget] + tonumber( SkillValue ) --不能通过' . '号来访问,[]
	end
end

