-- Halrt Hub: Fly Module (Safe Version)
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

shared.Flying = not shared.Flying

if shared.Flying then
    local bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1,1,1) * math.huge
    bv.Velocity = Vector3.new(0,0,0)
    bv.Name = "HalrtFly"
    
    task.spawn(function()
        while shared.Flying do
            RunService.RenderStepped:Wait()
            local cam = workspace.CurrentCamera.CFrame
            local dir = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
            bv.Velocity = dir * 50
        end
        bv:Destroy()
    end)
end
