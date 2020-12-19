-- Importing modules
mazeGenerator = require(script.Parent["Maze Generation"].MazeGenerator)
generateFeatures = require(script.Parent.Features)
miscellaneous = require(script.Parent.Misc)

-- Running functions
function createNewGame()
    mazeGenerator(16, 16)
    generateFeatures()
    miscellaneous()
end

return createNewGame