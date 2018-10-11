require "io"

Tab = {}

function Tab:Split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function Tab:Load(self, fileName)
	local f ,err = io.open( fileName , "r" )
	if err ~= nil then
		print( err.."加载文件失败，"..fileName.."文件可能不存在" )
	 	return
	end 
	if fileName then
		local firstLine = true
		for line in io.lines(fileName) do
			if firstLine then 
				if string.byte(line, 1) == 0xEF and string.byte(line, 2) == 0xBB and string.byte(line, 3) == 0xBF then
					line = string.sub(line, 4)
				end			
				self.tIndexTable = Tab:Split(line, "\t") 
				firstLine = false
			else
				local row = {}
				self[#self + 1] = row
				for i,v in ipairs(Tab:Split(line, "\t")) do
					if self.tIndexTable[i] then
						row[self.tIndexTable[i]] = v
						--print( v )
					end
				end
				--print( "..." )
			end
		end
		self.fileName = fileName
	end
end

function Tab:GetTableLen( t )
	local count = 0
	for i , item in pairs( t ) do
		count = count + 1
	end
	return count
end

function Tab:Write( self, fileName )
	if self == nil then
		print( "传入表为空，保存失败" )
		return
	end

	local IsFirst = true
	file = io.open( fileName, "w+" )
	if IsFirst == true then
		len = Tab:GetTableLen( self[1] )

		for i , item in pairs( self[1] ) do
			file:write(i)

			if len > 1 then
			 	file:write("\t")
			end
			len = len - 1 
		end
		file:write( "\n" )
		IsFirst = false
	end	
	for i = 1 , #self , 1 do
		local len = Tab:GetTableLen( self[i] )
		for key , value in pairs(self[i]) do
			file:write( value )
			if len > 1 then
			 	file:write("\t")
			end
			len = len - 1 
		end
		file:write( "\n" )
	end
	file:close()
end



--[[local  x = {} 
Tab:Load(x, "MySkiil.tab")

--print( "start" )
for i , record in ipairs( x ) do
	for j , name in pairs( record ) do
		print( name )
	end
	--print( "..." )
end

for i , item in ipairs(x) do
	print( x[i].SkillName )
	print( x[i].Attack )
end]]--