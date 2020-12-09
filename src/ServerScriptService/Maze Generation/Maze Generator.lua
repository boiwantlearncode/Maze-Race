-- Algorithm taken from https://clarkcoding.com/eller.html

Cell = require(script.Parent.Cell)

function generateMaze(numRows, numCols)
	maze = Instance.new("Model")
	rightWalls = Instance.new("Model")
	bottomWalls = Instance.new("Model")
	maze.Name = "Maze"
	rightWalls.Name = "RightWalls"
	bottomWalls.Name = "BottomWalls"
	
	local curRow = {}
	local numberInSet = {}
	local cell, addWall, removeWall
	
	for i=1, numCols do
		numberInSet[#numberInSet + 1] = 0
		cell = Cell.new()
		curRow[#curRow + 1] = cell
	end
	
	initialiseMaze(numRows, numCols)
	
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
			instantiateRow(i, curRow)
			
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
			
			instantiateRow(i, curRow)
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

function initialiseMaze(numRows, numCols)
	local cellSize = 10
	local wallHeight = 10
	local wallWidth = 5
	
	-- Top row
	local topWall = Instance.new("Part")
	topWall.Name = "TopWall"
	topWall.Anchored = true
	topWall.Size = Vector3.new((cellSize + wallWidth) * numCols + wallWidth, wallHeight, wallWidth)
	topWall.CFrame = CFrame.new(((cellSize + wallWidth) * numCols - wallWidth) / 2, wallHeight / 2, -(wallWidth / 2))
	topWall.Parent = maze
	
	-- Left row
	local leftWall = Instance.new("Part")
	leftWall.Name = "LeftWall"
	leftWall.Anchored = true
	leftWall.Size = Vector3.new(wallWidth, wallHeight, (cellSize + wallWidth) * numCols + wallWidth)
	leftWall.CFrame = CFrame.new(-(wallWidth / 2), wallHeight / 2, ((cellSize + wallWidth) * numCols - wallWidth) / 2)
	leftWall.Parent = maze
end

function instantiateRow(rowNumber, currentRow)
	
	local wallWidth = 5
	local wallHeight = 10
	local cellSize = 10
	
	for i, v in ipairs(currentRow) do
			
		if v.rightWall then
			local wall = Instance.new("Part")
			wall.Anchored = true
			
			wall.Size = Vector3.new(wallWidth + 0.003, wallHeight, cellSize + 2 * wallWidth + 0.003) -- the plusses is to remove the glitchy effect
			wall.Color = Color3.fromRGB(253, 135, 128)
			
			local WallX = i * cellSize + (i-1) * wallWidth + (wallWidth / 2)
			local WallY = wallHeight / 2
			local WallZ = (rowNumber - 1) * (cellSize + wallWidth) + (cellSize / 2)
			
			wall.CFrame = CFrame.new(WallX, WallY, WallZ)
			wall.Parent = rightWalls
		end
		if v.bottomWall then
			local wall = Instance.new("Part")
			wall.Anchored = true
			
			wall.Size = Vector3.new(cellSize + 2 * wallWidth, wallHeight + 0.003, wallWidth) -- the plusses is to remove the glitchy effect
			wall.Color = Color3.fromRGB(221, 0, 255)
			
			local WallX = (i - 1) * (cellSize + wallWidth) + (cellSize / 2)
			local WallY = wallHeight / 2
			local WallZ = rowNumber * cellSize + (rowNumber - 1) * wallWidth + (wallWidth / 2)
			
			wall.CFrame = CFrame.new(WallX, WallY, WallZ)
			wall.Parent = bottomWalls
		end
		
		
	end
end

return generateMaze