local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espEnabled = false
local boxes = {}

-- 1. Interfaz
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 120, 0, 90)
Main.Position = UDim2.new(0.5, -60, 0.2, 0) -- Aparece arriba para no molestar
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Draggable = true
Main.Active = true

local EspBtn = Instance.new("TextButton", Main)
EspBtn.Size = UDim2.new(1, -10, 0, 35)
EspBtn.Position = UDim2.new(0, 5, 0, 5)
EspBtn.Text = "ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
EspBtn.TextColor3 = Color3.new(1, 1, 1)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(1, -10, 0, 35)
CloseBtn.Position = UDim2.new(0, 5, 0, 45)
CloseBtn.Text = "Cerrar ESP"
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

-- 2. Función para crear la caja visual
local function createBox()
    local box = Drawing.new("Square")
    box.Color = Color3.new(1, 0, 0) -- Rojo
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    return box
end

-- 3. Lógica principal
RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, box in pairs(boxes) do box.Visible = false end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local box = boxes[player] or createBox()
                boxes[player] = box
                
                -- Calcular tamaño de la caja basado en la distancia
                local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local size = (1000 / distance) * 2
                
                box.Size = Vector2.new(size * 1.5, size * 2.5)
                box.Position = Vector2.new(screenPos.X - box.Size.X / 2, screenPos.Y - box.Size.Y / 2)
                box.Visible = true
                
                -- Color dinámico: Verde si es amigo o del mismo equipo (opcional)
                if player.Team == LocalPlayer.Team and player.Team ~= nil then
                    box.Color = Color3.new(0, 1, 0)
                else
                    box.Color = Color3.new(1, 0, 0)
                end
            elseif boxes[player] then
                boxes[player].Visible = false
            end
        elseif boxes[player] then
            boxes[player].Visible = false
        end
    end
end)

-- Botones
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = espEnabled and Color3.new(0, 0.7, 0) or Color3.new(0.7, 0, 0)
end)

CloseBtn.MouseButton1Click:Connect(function()
    espEnabled = false
    for _, box in pairs(boxes) do box:Remove() end
    ScreenGui:Destroy()
end)
