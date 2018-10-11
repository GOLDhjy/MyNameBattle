
MyEventSystem = {}
MyEventSystem.Listeners = {}

function MyEventSystem:RegisterEvent( event , callback )
	if MyEventSystem.Listeners.event == nil then
		MyEventSystem.Listeners.event = {}
	end
	for i , item in ipairs( MyEventSystem.Listeners.event ) do
		if MyEventSystem.Listeners.event[i] == callback then
			print( "已经添加，不要重复添加" )
			return
		end
	end
	table.insert( MyEventSystem.Listeners.event , #MyEventSystem.Listeners.event + 1, callback)
	
end

function MyEventSystem:DeleteEvent( event , callback )
	if event == nil then
		print( "event 为空" )
		return
	end
	if callback == nil then
		print( "callback为空" )
	end
	if MyEventSystem.Listeners.event == nil then
		print( "event不存在" )
		return
	end
	local index = nil 
	for i , item in ipairs( MyEventSystem.Listeners.event ) do
		if callback == MyEventSystem.Listeners.event[i] then
			index = i
			break
		end
	end
	if index == nil then
		print( "没找到该回调函数" )
		return
	end
	table.remove( MyEventSystem.Listeners.event, index )
end

function MyEventSystem:DoEvent( event , ...)
	if event == nil then
		print( "event为空" )
		return
	end
	if MyEventSystem.Listeners.event == nil then
		print( "不存在这个事件" )
		return
	end
	for i , fun in ipairs( MyEventSystem.Listeners.event ) do
		fun( ... )
	end
	--[[local arg = {...}
	LenArg = #arg
	if LenArg == 0 then
		for i , fun in ipairs( MyEventSystem.Listeners.event ) do
			fun( )
		end
	elseif LenArg == 1 then
		for i , fun in ipairs( MyEventSystem.Listeners.event ) do
			fun( arg[1] )
		end
	elseif LenArg == 2 then
		for i , fun in ipairs( MyEventSystem.Listeners.event ) do
			fun( arg[1] , arg[2] )
		end
	end]]--
end

