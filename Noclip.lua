-- Halrt Hub: Noclip Module
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

shared.NoclipEnabled = not shared.NoclipEnabled -- Alterna el estado cada vez que se carga

if shared.NoclipEnabled then
    -- Mensaje en consola para debug
    print("Halrt Hub: Noclip Activado")
    
    -- Creamos la conexión y la guardamos en una variable global para poder apagarla luego
    shared.NoclipConnection = RunService.Stepped:Connect(function()
        if shared.NoclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end)
else
    -- Si se vuelve a ejecutar, se apaga
    print("Halrt Hub: Noclip Desactivado")
    if shared.NoclipConnection then
        shared.NoclipConnection:Disconnect()
    end
    -- Devolvemos la colisión al personaje al apagarlo
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end
