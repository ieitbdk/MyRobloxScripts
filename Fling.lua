-- Fling Script para HalrtHub
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Creamos la fuerza de rotación
local function iniciarFling()
    local bAV = Instance.new("BodyAngularVelocity")
    bAV.Name = "HalrtFling"
    bAV.Parent = RootPart
    bAV.MaxTorque = Vector3.new(9e9, 9e9, 9e9) -- Fuerza infinita
    bAV.P = 1250 -- Potencia de respuesta
    bAV.AngularVelocity = Vector3.new(0, 99999, 0) -- Velocidad de rotación extrema

    -- Opcional: Hacerte "fantasma" para no salir volando tú mismo al chocar
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    print("Fling activado en Ieitbdk. ¡Acércate a alguien!")
    
    -- Se apaga después de 5 segundos para seguridad
    task.wait(5)
    bAV:Destroy()
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

iniciarFling()
