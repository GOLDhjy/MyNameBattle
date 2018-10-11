IdleAIState = IdleAIState or require "IdleAIState"
AttackAIState = AttackAIState or require "AttackAIState"
require "CharacterAI"
require "bit"
require "SkillSystem"
require "BuffSystem"
require "AchievementSystem"
require "FollowerCat"

Player ={Name , HP , Attack , IQ , Skill , Buff , Defense , Shooting , Dodge , IsShooting , IsDodge , Tmp = {}
, Cat , Title }

Player.fsm = CharacterAI:New()
Player.Turn = 0
--print( Player.fsm.CurrentState )
Player.fsm = CharacterAI:New()

function Player:SetTurn( valve )
	Player["Turn"] = tonumber(valve)
end

function Player:SetRounds( turn )
	if turn == "Attack" then
		self.fsm:PerformTransition( AttackAIState:New() )
	end
	if turn == "Idle" then
		self.fsm:PerformTransition( IdleAIState:New() )
	end
end

function Player:New( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self 	--把查询表设置为Player
	o.fsm = CharacterAI:New()
	o:CreateFSM()
	o.Tmp = {}
	print( "创建角色成功" )
	return o
end

function Player:CreateFSM( )
	Attack = AttackAIState:New()
	Idle = IdleAIState:New()
	--print( Attack )
	--print( Idle )
	self.fsm:AddState( Attack )
	print( "添加状态Attack成功" )
	--print( Player.fsm.CurrentState )

	self.fsm:AddState( Idle )
	print( "添加状态Idle成功" )
	--print( Player.fsm.CurrentState )
end

function Player:Update( Enemy )
		self.fsm.CurrentState:Update( self,Enemy )
		--self.fsm.CurrentState:Exit( self )
end

function Player:Init()  --角色的属性初始值在这里初始化
	local value = Player:Hash(self.Name)
	self.HP = tonumber(value) % 800
	self.Cat = FollowerCat:New( value )
	self.Title = AchievementSystem:GetTitle( self.Name )

	self.Attack = ( self:RandomValve( value )) % 100 

	--print( "初始攻击："..self.Attack )
	self.Defense = ( self:RandomValve() ) % 100
	self.Shooting = ( self:RandomValve() ) % 100
	self.Dodge = ( self:RandomValve() ) % 100
	self.IsShooting = false
	self.IsDodge = false
	--print( self.Cat.UpTarget )
	self[self.Cat.UpTarget] = self[self.Cat.UpTarget] + tonumber( self.Cat.UpValue )
	self:SaveDefaultField(  )
end

function Player:ShowPlayerInfo()
	print( "称号【"..self.Title.."】:"..self.Name.."  剩余血量:"..self.HP.."  攻击力:"..self.Attack )
	print( "防御力:"..self.Defense.."  命中率:"..self.Shooting.."  闪避率:"..self.Dodge)
	print( "宠物:"..self.Cat.CatName.."  宠物加成:"..self.Cat.UpTarget.." "..self.Cat.UpValue )
end

function Player:SetNameWithInit( str ) 
	if str == nil then
		print( "传入名字为空，初始化失败" )
		return
	end
	self.Name = str
	self:Init()
end

function Player:SaveDefaultField(  )
	self.Tmp.Attack = self.Attack  
	self.Tmp.Defense = self.Defense  
	self.Tmp.Shooting = self.Shooting  
	self.Tmp.Dodge = self.Dodge  
	self.Tmp.IsShooting = self.IsShooting
	self.Tmp.IsDodge = self.IsDodge
end

function Player:ConvertToDefaultField(  )
	self.Attack = self.Tmp.Attack
	self.Defense = self.Tmp.Defense  
	self.Shooting = self.Tmp.Shooting  
	self.Dodge = self.Tmp.Dodge  
	self.IsShooting = self.Tmp.IsShooting
	self.IsDodge = self.Tmp.IsDodge
end

function Player:ChangeAttackWithSkill( Skill )
	if Skill ~= nil then
		self.Attack = tonumber( Skill.Attack ) + self.Attack
	else
		self.Attack = tonumber( self.Skill.Attack ) + self.Attack
	end
	
end

function Player:ChangeFieldWithBuff( Buff ) --根据Buff修改属性
	if Buff ~= nil then
		if Buff.Target == "HP" then
			self.HP = self.HP * tonumber( Buff.Value )
		elseif Buff.Target == "Defense" then
			self.Defense = self.Defense * tonumber( Buff.Value )
		elseif Buff.Target == "Dodge" then
			self.IsDodge = true
		elseif Buff.Target == "Shooting" then
			self.IsShooting = true
		end
	else
		if self.Buff.Target == "HP" then
			self.HP = self.HP * tonumber( self.Buff.Value )
		elseif self.Buff.Target == "Defense" then
			self.Defense = self.Defense * tonumber( self.Buff.Value )
		elseif self.Buff.Target == "Dodge" then
			self.IsDodge = true
		elseif self.Buff.Target == "Shooting" then
			self.IsShooting = true
		end	
	end
end

function Player:ChangeSkill( Skill ) --设置技能
	if Skill ~= nil then
		self.Skill = Skill
	else
		Skill = SkillSystem:GetRandomSkill()
		self.Skill = Skill
	end
	self:ChangeAttackWithSkill()
end

function Player:ChangeBuff( Buff )  --设置Buff
	if Buff ~= nil then
		self.Buff = Buff
	else
		Buff = BuffSystem:GetRandomSkill()
		self.Buff = Buff
	end
	self:ChangeFieldWithBuff()
end

function Player:Hash( str ) --计算hash值
    local l = string.len(str)
    local h = l
    local step = bit.rshift(l, 5) + 1
    for i=l,step,-step do
        h = bit.bxor(h, (bit.lshift(h, 5) + string.byte(string.sub(str, i, i)) + bit.rshift(h, 2)))
    end
    return math.abs( h )
end

function Player:RandomValve( value ) --计算随机数
	if value ~=nil then
		math.randomseed( value )
	end
	return math.random( 10, 40 )
end

function Player:CalculateDamageToMe( Enemy )
	local Damage = Enemy.Attack - 0.4 * self.Defense
	return tonumber( Damage) 
end

function Player:CalculateDamageToOther( Enemy )
	local Damage = self.Attack - 0.4 * Enemy.Defense
	return Damage
end

function Player:DoAttackWithPicture( Skill )
	if Skill.SkillName == "六阳折梅手" then
	io.write( "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n",
	"MMMMMMMMMNd:cdk00KWMMMMMMMMMMMM\n",
	"MMMMMMMMXc     .:kNMMMMMMMMMMMM\n",
	"MMMMMMMM0'     :KMMMMMMMMMMMMMM\n",
	"MMMMMMMMN:    .lKWMMMMMMMMMMMMM\n",
	"MMMMMMMMWl      .;dXMMMMMMMMMMM\n",
	"MMMMMMMMWo         'okKNXNMMMMM\n",
	"MMMMMMMMMO.    .;;..  .;lx0NMMM\n",
	"MMMMMMMMMx.     :k0K0xdONWWWMMM\n",
	"MMMMMMMMK,        'lONMMMMMMMMM\n",
	"MMMMMMNx.            ;kWMMMMMMM\n",
	"MMMMMKc   .:lllccc.   .oNMMMMMM\n",
	"MMMMK;   ;KMMMMMMMXd.   lNMMMMM\n",
	"MMMWl  .lKMMMMMMMMMMKc 'OWMMMMM\n",
	"MMMk.'dXWMMMMMMMMMMMMK::xONMMMM\n",
	"MMKccKMMMMMMMMMMMMMMMWNXXKNMMMM\n",
	"MMNXNMMMMMMMMMMMMMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMMMMMMMMWXKNMMMMMMM\n" )
	elseif Skill.SkillName == "降龙十八掌" then	
	io.write( "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMWXOKWMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMWXKKNO' .oNMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMWO:...'.  .xWMMMMMMWWWMM\n",
"MMMMMMMMMMMMMMMMWx.       .':cc::c:;;:kW\n",
"MMMMMMMMMMMMMMMWO;      .:oxxdxxxxxxkOKM\n",
"MMMMMMMMMMMMMW0:.     .l0WMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMWk.      'OWMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMk.       .xWMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMx.  .     .kMMMMMMMMMMMMMMMM\n",
"MMMMMMMWWWKd'  ,kk:    ,0MMMMMMMMMMMMMMM\n",
"MMMMMMKc,,.  .cKMMNOo:. :XMMMMMMMMMMMMMM\n",
"MMMMMX: .';lxKWMMMMMMWx. ,xNMMMMMMMMMMMM\n",
"MMMMMk,c0NWMMMMMMMMMMMWk.  cXMMMMMMMMMMM\n",
"MMMMMNXWMMMMMMMMMMMMMMMWk. .oOXWMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMNd:cclOWMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n" )
	elseif Skill.SkillName == "天残脚" then
	io.write( "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0oOWMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx..kWMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0' .dNMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX;  ,0MMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0' ,0WMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKl'  oNMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNc    .xWMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk.   .kWMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl   .dWMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMXc    ;XMMMMMMMMMMMMMM\n",
"MMMMMMMMNklcdXMMMMMMMMMMMMMWx.    .oXMMMMMMMMMMMMM\n",
"MMMMMMMMk.   lNMMWNNWMMMMMNo.      'OMMMMMMMMMMMMM\n",
"MMMMMMMM0'   'k0o;'';::ccc;.    .cOXWMMMMMMMMMMMMM\n",
"MMMMMMMMWO,   ..                cNMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMWd.                   .kMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMW0;                    :XMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMK;                    .dMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMNd.                   .OMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMWXxl;'';:;,'.        ,KMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMWNWWMWWXo'.      lNMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMNdc'     .xMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMNol;     .xMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMXoxl     .xMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMN0Ko     .OMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMWo     '0MMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMNl     ,KMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMX:     :XMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMK,     oWMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMO.    .xMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMXc 'ldkONMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMWWX0x;  lNWMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMWKko:,'.'kWMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMWWWNNXXWMMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n" )
	end
end

function Player:DoBuffWithPicture( Buff )
	if Buff.BuffName == "天女散花" then
	io.write( "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMMMMMNKXXNMMMMMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMMMNx;::';xNMMMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMWO:.;xd:,.c0WMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMXl.,O0oclkx..oXMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMWl  oWo   ;0l  lWMMMMMMMMMMMM\n",
	"MMMMMMMMMMMWk. 'dc.  ;d, .xWMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMWx.          lNMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMWx.        :XMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMMN:        oWMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMMWo        oWMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMMW0;       .cKMMMMMMMMMMMMMM\n",
	"MMMMMMMMMMMMXd.          .oXMMMMMMMMMMMM\n",
	"MMMMMMMMMMNk,   .;cllc,    'xNMMMMMMMMMM\n",
	"MMMMMMMMMXl.  .:OWMMMMNOl'   cXMMMMMMMMM\n",
	"MMMMMMMMWo   ;0WMMMMMMMMMNd. .dWMMMMMMMM\n",
	"MMMMMMMM0'  :XMMMMMMMMMMMMMKl.;XMMMMMMMM\n",
	"MMMMMMMXc..lXMMMMMMMMMMMMMMMWk;lXMMMMMMM\n",
	"MMMMMMWOcxKWMMMMMMMMMMMMMMMMMMXKNMMMMMMM\n",
	"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n" )
	end
end

function Player:Piece(  )
	io.write( "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0dc:cxXMMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMWOc;:dOXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,     lNMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMW0c.     .':cc:cxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMO.     cNMMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMM0,           'clONMMMMMMMMMMMMMMMMMXdcdXMMMMMMMX:     ,kNMMMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMk.          .dWMMMMMMMMMMMMMMMMMMMMXl..xNXWNkolo:.      'cdkOXWMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMk.   ..     ,0MMMMMMMMMMMMMMMMMMMMNOc. ...,'                 .:ONMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMK,        .:OWMMMMMMMMMMMMMMMMMMMMk.                           .;dXMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMWl         .;kXWMMMMMMMMMMMMMMMMMMXkl;.                           'xNMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMWo            .;o0WMMMMMMMMMMMMMMMMMMWXOxxxkl.                     .dWMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMWo               .:OWMMMMMMMMMMMMMMMMMWOc;,;c.                      :NMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMx.                .l0KNWMMMMWWWMMMMMM0'                            ;KMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMM0,          ..      ..'cdkkxdOXWMMMMMk.                        ,lllkNMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMWl          ,d:.          .':lcoKWMMWd.                   ...:ONMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMNl          ;KWKOkxoc;'...dXNNNNNMMMX:                   l00XWMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMO.          .ckKNMMMMWNK0XWMMMMMMMMMXl.                 .kMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMWd.             .,o0WMMMMMMMMMMMMMMMMMWKk:  :dc'.        .OMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMXl.                 .;xKWMMMMMMMMMMMMMMMMWk. oWWNk,       .OMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMWO,                      .c0WMMMMMMMMMMMNkoc.  oWMMWk.      '0MMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMXo.                         .oXMMMMMMMMMMXdccc;'lXMMMWl      ,KMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMW0,       ';;::::::,;c,         :KWMMMMMMMMMMMMMWNNMMMMMK,     ;XMMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMWx.      .dXWWMMMMMWWWMNO:.       ,0MMMMMMMMMMMMMMMMMMMMMWO.    ,ONMMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMWx.      ;0WMMMMMMMMMMMMMMWO:.      'OWMMMMMMMMMMMMMMMMMMMMWk.    .,kWMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMM0'      .OMMMMMMMMMMMMMMMMMMNk,    .:OWMMMMMMMMMMMMMMMMMMMMMWk.     '0MMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMWo     'l0WMMMMMMMMMMMMMMMMMMMMNo. .kWMMMMMMMMMMMMMMMMMMMMMMMMW0;     oWMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMNd.  .ckNMMMMMMMMMMMMMMMMMMMMMMMMN: .ckXWMMMMMMMMMMMMMMMMMMMMMMMMXl. . .lKMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMK,  :KMMMMMMMMMMMMMMMMMMMMMMMMMMMWx',::lokXMMMMMMMMMMMMMMMMMMMMMMMW0Od.  lNMMMMMMMMMMMMMMM\n",
"MMMMMMMMM0:..xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNWMWNXXWMMMMMMMMMMMMMMMMMMMMMMMMWXl  ,0WMMMMMMMMMMMMMMM\n",
"MMMMMMMMNx::kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXd;,l0MMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWMMMMMMMMMMMMMMMMMMM\n",
"MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n" )
end
return Player


