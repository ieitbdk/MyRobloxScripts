local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local flying = false
local speed = 30 -- Bajamos la velocidad para ser discretos
local camera = workspace.CurrentCamera

-- Interfaz
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 120, 0, 90)
Main.Position = UDim2.new(0.5, -60, 0.8, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Draggable = true
Main.Active = true

local FlyBtn = Instance.new("TextButton", Main)
FlyBtn.Size = UDim2.new(1, -10, 0, 35)
FlyBtn.Position = UDim2.new(0, 5, 0, 5)
FlyBtn.Text = "Safe Fly: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(1, -10, 0, 35)
CloseBtn.Position = UDim2.new(0, 5, 0, 45)
CloseBtn.Text = "Cerrar y Limpiar"

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "Safe Fly: ON" or "Safe Fly: OFF"
    FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    
    if flying then
        local char = LocalPlayer.Character
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        -- Engañamos al juego diciendo que estamos en estado de "Plataforma"
        -- Esto a veces evita que el script de "caída mortal" se active
        task.spawn(function()
            while flying do
                local dt = RunService.Heartbeat:Wait()
                if char and root then
                    local moveDir = Vector3.new(0, 0, 0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                    
                    -- En lugar de BodyVelocity, movemos el RootPart suavemente
                    -- y reseteamos la velocidad de caída para no morir por "Falling"
                    root.Velocity = moveDir * speed + Vector3.new(0, 2, 0) 
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                end
            end
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    flying = false
    task.wait(0.2)
    ScreenGui:Destroy()
end)
