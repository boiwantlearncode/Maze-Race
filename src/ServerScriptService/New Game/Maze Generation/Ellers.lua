-- Algorithm taken from https://clarkcoding.com/eller.html
-- cellSize = 45; wallWidth = 25

Cell = require(script.Parent.Cell)

function ellers(numRows, numCols)
	-- local abstractMaze = {}
	local maze = Instance.new("Model")
	local topWalls = Instance.new("Model")
	local rightWalls = Instance.new("Model")
	local bottomWalls = Instance.new("Model")
	local leftWalls = Instance.new("Model")
	maze.Name = "Maze"
	topWalls.Name = "TopWalls"
	rightWalls.Name = "RightWalls"
	bottomWalls.Name = "BottomWalls"
	leftWalls.Name = "LeftWalls"

	local extendedHillUnits = {}
	
	table.insert(extendedHillUnits, game.ReplicatedStorage["Hill 1 Extended"])

	local curRow = {}
	local numberInSet = {}
	local cell, addWall, removeWall
	
	for i=1, numCols do
		numberInSet[#numberInSet + 1] = 0
		cell = Cell.new()
		curRow[#curRow + 1] = cell
	end
	
	initialiseMaze(numCols, extendedHillUnits, maze, topWalls, leftWalls)
	
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
			-- table.insert(abstractMaze, curRow)
			instantiateRow(i, numRows, curRow, extendedHillUnits, rightWalls, bottomWalls)
			
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
					mergeSets(curRow[j+1].id, curRow[j].id, numberInSet, curRow)
				end			
			end
			
			-- table.insert(abstractMaze, curRow)
			instantiateRow(i, numRows, curRow, extendedHillUnits, rightWalls, bottomWalls)
		end
	end
	
	topWalls.Parent = maze
	rightWalls.Parent = maze
	bottomWalls.Parent = maze
	leftWalls.Parent = maze
	maze.Parent = game.Workspace

	-- return abstractMaze -- returns abstract maze in table data structure
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

function initialiseMaze(mazeSize, extendedHillUnits, maze, topWalls, leftWalls)
	local cellSize = 45
	local wallHeight = extendedHillUnits[1].Size.Size.Y -- change
	local wallWidth = 25
	local extendedLength = 70
	local groundHeight = 2
	local mazeLength = extendedLength * mazeSize
	
	-- Lay the ground
	local ground = Instance.new("Part")
	ground.Name = "Ground"
	ground.Material = Enum.Material.Grass
	ground.Color = Color3.fromRGB(17,124,19)
	ground.Size = Vector3.new(mazeLength, groundHeight, mazeLength)
	ground.Position = Vector3.new((mazeLength - wallWidth) / 2, -(groundHeight / 2), (mazeLength - wallWidth) / 2)
	ground.Anchored = true
	ground.Parent = maze

	for i=1, mazeSize do -- this assumes that the maze is ALWAYS a square
		local topWall = extendedHillUnits[1]:Clone()

		local twX = (i - 1) * (cellSize + wallWidth) + (extendedLength / 2)
		local twY = wallHeight / 2
		local twZ = -(wallWidth / 2)
		
		topWall.PrimaryPart = topWall.Size
		topWall:SetPrimaryPartCFrame(CFrame.new(twX, twY, twZ))
		topWall.Parent = topWalls

		if i == 1 then -- this is to have an opening to enter the maze from
			continue
		end

		local leftWall = extendedHillUnits[1]:Clone()

		local lwX = -(wallWidth / 2)
		local lwY = wallHeight / 2
		local lwZ = (i - 1) * (cellSize + wallWidth) + (extendedLength / 2)
		
		leftWall.PrimaryPart = leftWall.Size
		leftWall:SetPrimaryPartCFrame(CFrame.new(lwX, lwY, lwZ) * CFrame.Angles(0, math.rad(-90), 0))
		leftWall.Parent = leftWalls
	end
end

function randomUnit(table)
	return table[math.random(1, #table)]
end

function instantiateRow(rowNumber, numRows, currentRow, extendedHillUnits, rightWalls, bottomWalls)

	-- Let's standardise
	-- Only height is not standardised. For hill biome:
	-- Extended: 70, x, 25
	local cellSize = 45 
	local rwLength = 45 -- it's not the wall's length but for the position
	local rwWidth = 25
	local bwLength = 70
	local bwWidth = 25
	-- local groundHeight = 2
	
	for i, v in ipairs(currentRow) do
		if v.rightWall then
			local rightWall
			if i ~= #currentRow then
				rightWall = randomUnit(extendedHillUnits):Clone() -- may change to exclude wall at index 1
			else
				rightWall = extendedHillUnits[1]:Clone()
			end
			rightWall.PrimaryPart = rightWall.Size
				
			local rwHeight = rightWall.Size.Size.Y
			local rwX = (i - 1) * (cellSize + rwWidth) + cellSize + (rwWidth / 2)
			local rwY = rwHeight / 2
			local rwZ = (rowNumber - 1) * (cellSize + bwWidth) + (rwLength / 2)
			
			rightWall:SetPrimaryPartCFrame(CFrame.new(rwX, rwY, rwZ) * CFrame.Angles(0, math.rad(-90), 0))
			rightWall.Parent = rightWalls
		end
		if v.bottomWall then
			local bottomWall 
			if rowNumber ~= numRows then
				bottomWall = randomUnit(extendedHillUnits):Clone() -- may change to exclude wall at index 1
			else
				bottomWall = extendedHillUnits[1]:Clone()
			end
			bottomWall.PrimaryPart = bottomWall.Size

			local bwHeight = bottomWall.Size.Size.Y

			local bwX = (i - 1) * (cellSize + rwWidth) + (bwLength / 2)
			local bwY = bwHeight / 2
			local bwZ = (rowNumber - 1) * (cellSize + bwWidth) + cellSize + (bwWidth / 2)
			
			bottomWall:SetPrimaryPartCFrame(CFrame.new(bwX, bwY, bwZ))
			bottomWall.Parent = bottomWalls
		end
		
	end
end

return ellers