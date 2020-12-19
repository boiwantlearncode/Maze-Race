local Cell = {}
Cell.__index = Cell

function Cell.new()
	local newCell = {}
	setmetatable(newCell, Cell)

	newCell.bottomWall = true
	newCell.rightWall = false
	newCell.id = -1

	return newCell
end

function Cell:joinToUniqueSet(numberInSet)
	if self.id > 0 then
		return
	end	
	for i=1, #numberInSet do
		if numberInSet[i] == 0 then
			self.id = i
			numberInSet[i] = numberInSet[i] + 1
			break
		end
	end
end

return Cell