require "bit"
require "Tab"

math.randomseed( "123" )
for i = 1, 10 do
	print( i,math.random( 0, 100 ) )
end

local function JSHash(str)
    local l = string.len(str)
    local h = l
    local step = bit.rshift(l, 5) + 1
    for i=l,step,-step do
        h = bit.bxor(h, (bit.lshift(h, 5) + string.byte(string.sub(str, i, i)) + bit.rshift(h, 2)))
    end
    return h
end

print( math.abs(JSHash("我的名字"))%1000 )



local xx = {"name","Age",Girl = ta} 
print( "长度为："..#xx )

local x = {{Name = "hjy" , Age = 22},{Name = "233" , Age = 21},{Name = "233" , Age = 21},{Name = "hjy" , Age = 22}} 
Tab:Write( x, "myinfo.tab" )

local info = { }
Tab:Load(info, "myinfo.tab")

for i = 1, #info,1 do
	for key , value in pairs( info[i] ) do
		print( key.."="..value )
	end
	print( "___" )
end

