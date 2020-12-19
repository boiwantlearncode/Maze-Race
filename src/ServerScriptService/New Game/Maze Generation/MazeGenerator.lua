ellers = require(script.Parent.Ellers)
-- prims = require(script.Parent.Prims)

function generateMaze(numRows, numCols)
	print(ellers(numRows, numCols))


	-- local randomChoice = math.random(1, 2)
	-- local abstractMaze

	-- if randomChoice == 1 then
	-- 	while true do
	-- 		abstractMaze = ellers(numRows, numCols)
	-- 		if shortestPath(abstractMaze) >= 35 then
	-- 			break
	-- 		end
	-- 	end
	-- else
	-- 	while true do
	-- 		abstractMaze = prims(numRows, numCols)
	-- 		if shortestPath(abstractMaze) >= 35 then
	-- 			break
	-- 		end
	-- 	end
	-- end
end

return generateMaze