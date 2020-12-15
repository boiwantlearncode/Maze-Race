-- Algorithm taken from https://clarkcoding.com/eller.html

Cell = require(script.Parent.Cell)

function callGenerateMaze(numRows, numCols)
	generateMaze(numRows, numCols, {})
end

function generateMaze(numRows, numCols, rowAbove)
	maze = Instance.new("Model")
	rightWalls = Instance.new("Model")
	bottomWalls = Instance.new("Model")
	maze.Name = "Maze"
	rightWalls.Name = "RightWalls"
	bottomWalls.Name = "BottomWalls"

	local normalHillUnits = {}
	local extendedHillUnits = {}
	
	table.insert(normalHillUnits, game.ReplicatedStorage["Hill 1"])
	table.insert(extendedHillUnits, game.ReplicatedStorage["Hill 1 Extended"])

	local curRow = {}
	local numberInSet = {}
	local cell, addWall, removeWall
	
	for i=1, numCols do
		numberInSet[#numberInSet + 1] = 0
		cell = Cell.new()
		curRow[#curRow + 1] = cell
	end
	
	initialiseMaze(numRows, numCols, extendedHillUnits)
	
	for i=1, numRows do
		
		-- Put setless cells into unique sets
		for j=1, numCols do
			curRow[j]:joinToUniqueSet(numberInSet)
		end
		
		-- Add right walls
		for j=1, numCols do
			if j == numCols then
				curRow[j].rightWall = true
				break
			end
			
			if curRow[j].id == curRow[j+1].id then
				curRow[j].rightWall = true
			else
				addWall = math.random() >= 0.5
				curRow[j].rightWall = addWall
				if not addWall then
					mergeSets(curRow[j].id, curRow[j+1].id, numberInSet, curRow)
				end
			end
		end
		
		-- Add bottom walls
		for j=1, numCols do
			removeWall = math.random() >= 0.5
			if numberInSet[curRow[j].id] == 1 then
				removeWall = true
			end
			
			curRow[j].bottomWall = not removeWall
			
			if not removeWall then
				numberInSet[curRow[j].id] = numberInSet[curRow[j].id] - 1
			end
		end
		
		-- Generate new row
		if i ~= numRows then
			instantiateRow(i, numRows, curRow, rowAbove, normalHillUnits, extendedHillUnits)
			rowAbove = curRow
			
			for j=1, #numberInSet do
				numberInSet[j] = 0
			end
			
			for j=1, numCols do
				curRow[j].rightWall = false
				if curRow[j].bottomWall then
					curRow[j].id = -1
				else
					numberInSet[curRow[j].id] = numberInSet[curRow[j].id] + 1
				end
				curRow[j].bottomWall = true
			end
		else
			for j=1, numCols do
				curRow[j].bottomWall = true
				if j == #curRow then
					curRow[j].rightWall = true
					break
				end
				if curRow[j].id ~= curRow[j+1].id then
					curRow[j].rightWall = false
					mergeSets(curRow[j].id, curRow[j+1].id, numberInSet, curRow)
				end			
			end
			
			instantiateRow(i, numRows, curRow, rowAbove, normalHillUnits, extendedHillUnits)
		end
	end
	
	rightWalls.Parent = maze
	bottomWalls.Parent = maze
	maze.Parent = game.Workspace
end


function mergeSets(leftSetID, rightSetID, numberInSet, cells)
	for i=1, #cells do
		if cells[i].id == rightSetID then
			cells[i].id = leftSetID
			numberInSet[rightSetID] = numberInSet[rightSetID] - 1 
			numberInSet[leftSetID] = numberInSet[leftSetID] + 1
		end
		if numberInSet[rightSetID] == 0 then
			break
		end
	end
end

function initialiseMaze(numRows, numCols, extendedHillUnits)
	local cellSize = 45
	local wallHeight = extendedHillUnits[1].Size.Size.Y -- change
	local wallWidth = 25
	
	-- Top row
	local topWall = extendedHillUnits[1]:Clone()
	topWall.Name = "TopWall"
	-- topWall.Anchored = true
	-- topWall.Size = Vector3.new((cellSize + wallWidth) * numCols + wallWidth, wallHeight, wallWidth)
	-- topWall.CFrame = CFrame.new(((cellSize + wallWidth) * numCols - wallWidth) / 2, wallHeight / 2, -(wallWidth / 2))
	topWall.PrimaryPart = topWall.Size
	topWall:SetPrimaryPartCFrame(CFrame.new(((cellSize + wallWidth) * numCols - wallWidth) / 2, wallHeight / 2, -(wallWidth / 2)))
	topWall.Parent = maze
	
	-- Left row
	local leftWall = extendedHillUnits[1]:Clone()
	leftWall.Name = "LeftWall"
	-- leftWall.Anchored = true
	-- leftWall.Size = Vector3.new(wallWidth, wallHeight, (cellSize + wallWidth) * numCols + wallWidth)
	-- leftWall.CFrame = CFrame.new(-(wallWidth / 2), wallHeight / 2, ((cellSize + wallWidth) * numCols - wallWidth) / 2)
	leftWall.PrimaryPart = leftWall.Size
	leftWall:SetPrimaryPartCFrame(CFrame.new(((cellSize + wallWidth) * numCols - wallWidth) / 2, wallHeight / 2, -(wallWidth / 2)) * CFrame.Angles(0, math.rad(90), 0))
	leftWall.Parent = maze
end

function randomUnit(table)
	return table[math.random(1, #table)]
end

function instantiateRow(rowNumber, numRows, currentRow, rowAbove, normalHillUnits, extendedHillUnits)

	-- Let's standardise
	-- Only height is not standardised. For hill biome:
	-- Normal: 45, x, 25. Extended: 70, x, 25
	local cellSize = 45 -- same as normal Hill unit length
	local rwLength = 45
	local rwWidth = 25
	local bwLength = 70
	local bwWidth = 25
	
	for i, v in ipairs(currentRow) do
		if rowNumber == 1 then
			if v.rightWall then
				local rightWall  = normalHillUnits[1]:Clone()
				rightWall.PrimaryPart = rightWall.Size
				
				local rwHeight = rightWall.Size.Size.Y

				local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
				local rwY = rwHeight / 2
				local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
				
				rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
				rightWall.Parent = rightWalls
			end

			if v.bottomWall then
				local bottomWall = randomUnit(extendedHillUnits):Clone()
				bottomWall.PrimaryPart = bottomWall.Size

				local bwHeight = bottomWall.Size.Size.Y

				local bwX = (i - 1) * (cellSize + rwWidth) + (bwLength / 2)
				local bwY = bwHeight / 2
				local bwZ = (rowNumber - 1) * (cellSize + bwWidth) + cellSize + (bwWidth / 2)
				
				bottomWall:SetPrimaryPartCFrame(CFrame.new(bwX, bwY, bwZ))
				bottomWall.Parent = bottomWalls
			end
		end

		if i == #currentRow then
			local rightWall  = extendedHillUnits[1]:Clone()
			rightWall.PrimaryPart = rightWall.Size
			
			local rwHeight = rightWall.Size.Size.Y

			local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
			local rwY = rwHeight / 2
			local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
			
			rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
			rightWall.Parent = rightWalls

			if v.bottomWall then
				local bottomWall = randomUnit(extendedHillUnits):Clone()
				bottomWall.PrimaryPart = bottomWall.Size

				local bwHeight = bottomWall.Size.Size.Y

				local bwX = (i - 1) * (cellSize + rwWidth) + (bwLength / 2)
				local bwY = bwHeight / 2
				local bwZ = (rowNumber - 1) * (cellSize + bwWidth) + cellSize + (bwWidth / 2)
				
				bottomWall:SetPrimaryPartCFrame(CFrame.new(bwX, bwY, bwZ))
				bottomWall.Parent = bottomWalls
			end

			return
		end

		-- if rowNumber == numRows then
		-- 	local bottomWall = extendedHillUnits[1]:Clone()
		-- 	bottomWall.PrimaryPart = bottomWall.Size

		-- 	local bwHeight = bottomWall.Size.Size.Y

		-- 	local bwX = (i - 1) * (cellSize + rwWidth) + (bwLength / 2)
		-- 	local bwY = bwHeight / 2
		-- 	local bwZ = (rowNumber - 1) * (cellSize + bwWidth) + cellSize + (bwWidth / 2)
			
		-- 	bottomWall:SetPrimaryPartCFrame(CFrame.new(bwX, bwY, bwZ))
		-- 	bottomWall.Parent = bottomWalls

		-- 	if v.rightWall then
		-- 		local rightWall  = randomUnit(normalHillUnits):Clone()
		-- 		rightWall.PrimaryPart = rightWall.Size
				
		-- 		local rwHeight = rightWall.Size.Size.Y
	
		-- 		local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
		-- 		local rwY = rwHeight / 2
		-- 		local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
				
		-- 		rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
		-- 		rightWall.Parent = rightWalls
		-- 	end

		-- 	return
		-- end

		if v.rightWall then
			if v.bottomWall then
				local rightWall  = randomUnit(normalHillUnits):Clone()
				local bottomWall = randomUnit(extendedHillUnits):Clone()

				rightWall.PrimaryPart = rightWall.Size
				bottomWall.PrimaryPart = bottomWall.Size

				-- rwLength == cellSize
				local rwHeight = rightWall.Size.Size.Y
				local bwHeight = bottomWall.Size.Size.Y

				-- local rwX = i * cellSize + (i-1) * wallWidth + (wallWidth / 2)
				-- local rwY = wallHeight / 2 -- change to get Y-value of wall
				-- local rwZ = (rowNumber - 1) * (cellSize + wallWidth) + (cellSize / 2)
				local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
				local rwY = rwHeight / 2
				local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
				
				rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
				rightWall.Parent = rightWalls

				-- local bwX = (i - 1) * (cellSize + wallWidth) + (cellSize / 2)
				-- local bwY = wallHeight / 2 -- change to get Y-value of wall
				-- local bwZ = rowNumber * cellSize + (rowNumber - 1) * wallWidth + (wallWidth / 2)
				
				local bwX = (i - 1) * (cellSize + rwWidth) + (bwLength / 2)
				local bwY = bwHeight / 2
				local bwZ = (rowNumber - 1) * (cellSize + bwWidth) + cellSize + (bwWidth / 2)
				
				bottomWall:SetPrimaryPartCFrame(CFrame.new(bwX, bwY, bwZ))
				bottomWall.Parent = bottomWalls

			elseif rowNumber ~= 1 and rowAbove[i].bottomWall then
				local rightWall  = randomUnit(normalHillUnits):Clone()
				rightWall.PrimaryPart = rightWall.Size

				local rwHeight = rightWall.Size.Size.Y

				local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
				local rwY = rwHeight / 2
				local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
				
				rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
				rightWall.Parent = rightWalls

			elseif i ~= #currentRow then
				print(rowAbove)
				if currentRow[i+1].bottomWall then
					local rightWall  = randomUnit(normalHillUnits):Clone()

					rightWall.PrimaryPart = rightWall.Size

					local rwHeight = rightWall.Size.Size.Y

					local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
					local rwY = rwHeight / 2
					local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
					
					rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
					rightWall.Parent = rightWalls
				elseif rowNumber ~= 1 and rowAbove[i+1].bottomWall then
					print('One')
					local rightWall  = randomUnit(normalHillUnits):Clone()

					rightWall.PrimaryPart = rightWall.Size

					local rwHeight = rightWall.Size.Size.Y

					local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
					local rwY = rwHeight / 2
					local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
					
					rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
					rightWall.Parent = rightWalls
				
				else
					print('two')
					local rightWall  = randomUnit(extendedHillUnits):Clone()
					rightWall.PrimaryPart = rightWall.Size

					local rwHeight = rightWall.Size.Size.Y

					local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
					local rwY = rwHeight / 2
					local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
					
					rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
					rightWall.Parent = rightWalls
				end
			end

		elseif v.bottomWall then
			local bottomWall = randomUnit(extendedHillUnits):Clone()
			bottomWall.PrimaryPart = bottomWall.Size
			local bwHeight = bottomWall.Size.Size.Y
	
			local bwX = (i - 1) * (cellSize + rwWidth) + (bwLength / 2)
			local bwY = bwHeight / 2
			local bwZ = (rowNumber - 1) * (cellSize + bwWidth) + cellSize + (bwWidth / 2)
			
			bottomWall:SetPrimaryPartCFrame(CFrame.new(bwX, bwY, bwZ))
			bottomWall.Parent = bottomWalls
		end

		-- if v.rightWall then
		-- 	local wall = Instance.new("Part")
		-- 	wall.Anchored = true
			
		-- 	wall.Size = Vector3.new(wallWidth + 0.003, wallHeight, cellSize + 2 * wallWidth + 0.003) -- the plusses is to remove the glitchy effect
		-- 	wall.Color = Color3.fromRGB(253, 135, 128)
			
		-- 	local WallX = i * cellSize + (i-1) * wallWidth + (wallWidth / 2)
		-- 	local WallY = wallHeight / 2
		-- 	local WallZ = (rowNumber - 1) * (cellSize + wallWidth) + (cellSize / 2)
			
		-- 	wall.CFrame = CFrame.new(WallX, WallY, WallZ)
		-- 	wall.Parent = rightWalls
		-- end
		-- if v.bottomWall then
		-- 	local wall = Instance.new("Part")
		-- 	wall.Anchored = true
			
		-- 	wall.Size = Vector3.new(cellSize + 2 * wallWidth, wallHeight + 0.003, wallWidth) -- the plusses is to remove the glitchy effect
		-- 	wall.Color = Color3.fromRGB(221, 0, 255)
			
		-- 	local WallX = (i - 1) * (cellSize + wallWidth) + (cellSize / 2)
		-- 	local WallY = wallHeight / 2
		-- 	local WallZ = rowNumber * cellSize + (rowNumber - 1) * wallWidth + (wallWidth / 2)
			
		-- 	wall.CFrame = CFrame.new(WallX, WallY, WallZ)
		-- 	wall.Parent = bottomWalls
		-- end
		
		
	end
end

return callGenerateMaze