mazeDistance = require(script.Parent.MazeDistance)
ellers = require(script.Parent.Ellers)
-- prims = require(script.Parent.Prims)

function generateMaze(numRows, numCols)
	-- local abstractMaze
	local distance
	local start = Vector3.new(22.5, -0.5, 22.5)
	local finish = Vector3.new((numRows - 1) * 70 + 22.5, -0.5, (numCols - 1) * 70 + 22.5)

	while true do
		ellers(numRows, numCols)
		distance = mazeDistance(start, finish)
		print(distance)
		if distance > 2200 then -- will have to change
			break
		end
		game.Workspace.Maze:Destroy()
	end


	-- local randomChoice = math.random(1, 2)

	-- if randomChoice == 1 then
	-- 	while true do
	-- 		abstractMaze = ellers(numRows, numCols)
	-- 		if shortestPath(abstractMaze) >= 35 then
	-- 			break
	-- 		end
	--		game.Workspace.Maze:Destroy()
	-- 	end
	-- else
	-- 	while true do
	-- 		abstractMaze = prims(numRows, numCols)
	-- 		if shortestPath(abstractMaze) >= 35 then
	-- 			break
	-- 		end
	--		game.Workspace.Maze:Destroy()
	-- 	end
	-- end
end

return generateMaze