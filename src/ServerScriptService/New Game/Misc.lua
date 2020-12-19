-- default WalkSpeed = 48

function miscellaneous()
    removeForceField()
    setPlayerSpeeds() -- only applies to those with speed boosts, permanent or temporary. may move to Features
end

function removeForceField()
    game.Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(Character)
            local ForceField = Character:WaitForChild("ForceField")
            ForceField:Destroy()
        end)
    end)
end

function setPlayerSpeeds()

end

return miscellaneous