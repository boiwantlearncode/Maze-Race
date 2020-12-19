-- cellSize = 45

function generateFeatures()
    createSpawnAndEnd()
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

    -- create end
    -- either cave exit (thematic) or beams
end


return generateFeatures