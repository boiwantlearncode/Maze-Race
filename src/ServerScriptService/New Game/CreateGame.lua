-- Importing modules
mazeGenerator = require(script.Parent["Maze Generation"].MazeGenerator)
generateFeatures = require(script.Parent.Features)
miscellaneous = require(script.Parent.Misc)

-- Running functions
function createNewGame()
    mazeGenerator(20, 20)
    generateFeatures()
    miscellaneous()
end

return createNewGame