-- Importing modules
mazeGenerator = require(game.ServerScriptService["Maze Generation"]["Maze Generator"])

-- Running functions
mazeGenerator(10, 10)

local unit = game.Workspace["Unit 1"]
print(unit:GetExtentsSize())