IdleAIState = IdleAIState or require "IdleAIState"
AttackAIState = AttackAIState or require "AttackAIState"

CharacterAI = {}
--CurrentState = AIState:New()
CharacterAI.States = {}
CharacterAI.CurrentState = IdleAIState:New()
function CharacterAI:New( o )
	o = o or {}
	setmetatable( o , self  )
	self.__index = self;
	o.States = {}
	o.CurrentState = nil
	return o;
end
function CharacterAI:AddState( s )
	if s == nil then
		print( "传入值为空" )
		return
	end
	if self.States[s.Name] ~= nil then
		print( "状态机里已存在" )
		return
	end
	if  self.States[s.Name] == nil then 
		self.States[s.Name] = true
		self.CurrentState = s
		print( "添加状态"..s.Name.."成功" )
	end
	--print( CharacterAI.States["s"] )
end
function CharacterAI:DeleteState( s )
			if  self.States[s.Name] == true then
				self.States[s.Name] = false
			else
				print( "Error for DeleteState" )
			end
end
function CharacterAI:PerformTransition( state )
	--print( "改变状态：" )
	--print( state )
	if state == nil then 
		print( "Error for PerformTransition (state is nil)" )
		return
	end
		if self.States[state.Name] == true then
			--CharacterAI.CurrentState.Exit()
			self.CurrentState = state
			--print( state.Name.."修改完毕" )
			--CharacterAI.CurrentState.Init()
			return
		end
	print( "修改失败" )
end
return CharacterAI