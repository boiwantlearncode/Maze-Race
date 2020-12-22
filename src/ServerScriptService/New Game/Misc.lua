-- default WalkSpeed = 48

function miscellaneous()
    removeForceField()
end

function removeForceField()
    game.Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(Character)
            local ForceField = Character:WaitForChild("ForceField")
            ForceField:Destroy()
        end)
    end)
end

return miscellaneous