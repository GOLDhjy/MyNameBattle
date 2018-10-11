require "MyEventSystem"

fun = function ( n )
	print( n )
end

local x = {}
x[1] = fun
for i , f in ipairs( x ) do
	x[i](i)
end

MyEventSystem:RegisterEvent("print",fun)

MyEventSystem:DoEvent("print",86336)

