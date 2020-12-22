-- cellSize = 45

function generateFeatures()
    createSpawnAndEnd()
    -- spawnChests(abstractMaze)
end

function createSpawnAndEnd()
    -- create spawn
    local startSpawn = Instance.new("SpawnLocation")
    startSpawn.Anchored = true
    startSpawn.Transparency = 1
    startSpawn.Size = Vector3.new(1, 1, 1)
    startSpawn.Position = Vector3.new(22.5, -0.5, 22.5)
    startSpawn.CanCollide = false
    startSpawn.Parent = game.Workspace

    -- create holding area
    -- cave exit (thematic) rendered in eller's and prim's scripts
end

-- NOTE: this implementation is according to eller's algorithm where each cell is only assigned bottomWall
-- or rightWall. When implementing new algorithms, ensure that each cell follow the same standard!
function spawnChests(abstractMaze)
    local maze = game.Workspace.Maze
    local chests = game.ReplicatedStorage.Assets.Chests -- first, must create the folder of chests.
    local chestFolder = Instance.new("Folder")
    chestFolder.Name = "Chests"
    local clonedChests = {}

    local speedBoostChest1 = chests["Speed Boost Chest"]:Clone()
    table.insert(clonedChests, speedBoostChest1)
    local speedBoostChest2 = chests["Speed Boost Chest"]:Clone()
    table.insert(clonedChests, speedBoostChest2)
    local freezeChest1 = chests["Freeze Spell Chest"]:Clone()
    table.insert(clonedChests, freezeChest1)
    local freezeChest2 = chests["Freeze Spell Chest"]:Clone()
    table.insert(clonedChests, freezeChest2)
    local mapChest = chests["Map Chest"]
    table.insert(clonedChests, mapChest)
    local randomChest1 = chests["Random Chest"]:Clone()
    table.insert(clonedChests, randomChest1)
    local randomChest2 = chests["Random Chest"]:Clone()
    table.insert(clonedChests, randomChest2)

    -- Generate random spawnable coordinates
    -- Need to double check chestHeight because when opened it's taller
    local chestHeight = 6.4
    local chestLength = 8
    local chestWidth = 5.6

    local mazeSize = #abstractMaze -- assumes that the maze is a square
    local randomRow, randomCol, randomCell
    local chestX, chestZ
    local chestY = chestHeight / 2 -- refer to standardised height of chest (STANDARDISE CHEST HEIGHT)
    local chestPosition

    for _, chest in ipairs(clonedChests) do -- need to pass in abstractMaze argument as the chest will have to be against a wall
        while true do
            randomRow = math:random(1, mazeSize) -- double check if mazeSize is a single value or double; expected single
            randomCol = math:random(1, mazeSize)
            randomCell = abstractMaze[randomRow][randomCol]
            
            if randomCell.bottomWall then
                chestX = 70 * (randomCol - 1) + math:random(chestLength / 2, 45 - (chestLength / 2))
                chestZ = 70 * (randomRow - 1) + 45 - (chestWidth / 2)
                chestPosition = CFrame.new(chestX, chestY, chestZ)

            elseif randomCell.rightWall then
                chestX = 70 * (randomCol - 1) + 45 - (chestWidth / 2)
                chestZ = 70 * (randomRow - 1) + math:random(chestLength / 2, 45 - (chestLength / 2))
                chestPosition = CFrame.new(chestX, chestY, chestZ)

            elseif abstractMaze[randomRow - 1][randomCol].bottomWall then -- i.e. topWall to cell
                chestX = 70 * (randomCol - 1) + math:random(chestLength / 2, 45 - (chestLength / 2))
                chestZ = 70 * (randomRow - 1) + (chestWidth / 2)
                chestPosition = CFrame.new(chestX, chestY, chestZ)

            elseif abstractMaze[randomRow][randomCol - 1].rightWall then -- i.e. leftWall to cell
                chestX = 70 * (randomCol - 1) + (chestWidth / 2)
                chestZ = 70 * (randomRow - 1) + math:random(chestLength / 2, 45 - (chestLength / 2))
                chestPosition = CFrame.new(chestX, chestY, chestZ)

            else
                continue
            end

            break
        end
        
        chest.Position = chestPosition
        chest.Parent = chestFolder
    end

    chestFolder.Parent = maze

end


return generateFeatures