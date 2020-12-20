function mazeDistance(start, finish)
    -- local pathObject = Instance.new("Model")
    -- pathObject.Name = "Path"
    local totalDistance = 0
    local previousPosition
    local PathfindingService = game:GetService("PathfindingService")
    local path = PathfindingService:CreatePath()
     
    path:ComputeAsync(start, finish)
     
    local waypoints = path:GetWaypoints()

    for i, waypoint in ipairs(waypoints) do
        -- if i % 5 ~= 1 then
        --     continue
        -- end
        -- local part = Instance.new("Part")
        -- part.Color = Color3.fromRGB(240, 240, 17)
        -- part.Shape = "Ball"
        -- part.Material = "Neon"
        -- part.Size = Vector3.new(3, 3, 3)
        -- part.Position = waypoint.Position + Vector3.new(0, 3, 0)
        -- part.Anchored = true
        -- part.CanCollide = false
        -- part.Parent = path

        if i ~= 1 then
            totalDistance = totalDistance + (waypoint.Position - previousPosition).Magnitude
        end
        previousPosition = waypoint.Position
    end

    -- pathObject.Parent = game.Workspace.Maze

    return totalDistance
end


return mazeDistance