--loadstring(game:HttpGet("https://raw.githubusercontent.com/t1k3rr/Roblox-Scripts/main/JailBird.lua"))()
if (not ethanstoptryingtoloadthisshit) then
    getgenv().ethanstoptryingtoloadthisshit = ""
else
    return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/t1k3rr/Roblox-Scripts/main/jailbird-130dmg"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/t1k3rr/Roblox-Scripts/main/anti-kick.lua"))()

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local highlighter = loadstring(game:HttpGet("https://raw.githubusercontent.com/t1k3rr/Roblox-Scripts/main/highlighter%20for%20jailbird"))()
local aimbottoggle = false;
local ESPtog = false;
local outlineColor = Color3.fromRGB(252, 3, 194)
local fillcolor = Color3.fromRGB(0, 0, 0)
local fillt = 0.5
getgenv().fov = 30
local camFOV = false
local smoothing = 0
local ready = true;
local bartog = false;
local map = nil
local RunService = game:GetService("RunService")

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 2
FOVring.Radius = fov
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(255, 128, 128)
FOVring.Position = workspace.CurrentCamera.ViewportSize/2

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/t1k3rr/Roblox-Scripts/main/library%20for%20jailbird')))()

local w = library:CreateWindow("by xyz.8710")
local AimWindow = w:CreateFolder("Aimbot") -- Creates the folder(U will put here your buttons,etc)
local VisualWindow = w:CreateFolder("Visuals") -- Creates the folder(U will put here your buttons,etc)
local MiscWindow = w:CreateFolder("Misc") -- Creates the folder(U will put here your buttons,etc)


AimWindow:Toggle("Enable",function(bool)
    aimbottoggle = bool
end)

AimWindow:Slider("FOV",{
    min = 1; -- min value of the slider
    max = 100; -- max value of the slider
    precise = true; -- max 2 decimals
},function(value)
    fov = tonumber(value)
    FOVring.Radius = fov    
end)

AimWindow:Toggle("Show FOV",function(bool)
    FOVring.Visible = bool
end)

VisualWindow:Toggle("Enable ESP", function(t)
    ESPtog = t
end)

VisualWindow:Toggle("Better FOV", function(t)
    camFOV = t
end)



MiscWindow:Toggle("BUFF Barricades", function(t)
    for i,v in pairs(workspace.Map:GetDescendants()) do
        if (v.Name == 'BarricadeArea') then
            map = v
        end
    end
    bartog = t
end)


local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
    
    local target = nil
    local mag = math.huge
    
    for i,v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.PrimaryPart ~= nil and v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and workspace.PlayersFolder:FindFirstChild(v.Name) then
            local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude
            
            if magBuf < mag then
                mag = magBuf
                target = v
            end
        end
    end
    
    return target
end

loop = RunService.RenderStepped:Connect(function()
    local UserInputService = game:GetService("UserInputService")
    local pressed = --[[UserInputService:IsKeyDown(Enum.KeyCode.E)]] UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    local localPlay = Character
    local cam = workspace.CurrentCamera
    local zz = workspace.CurrentCamera.ViewportSize/2
    if (camFOV) then
        if (cam.FieldOfView < 70) then
            cam.FieldOfView = 70
        else
            cam.FieldOfView = 90
        end
    end
    
    if pressed and aimbottoggle then
        local Line = Drawing.new("Line")
        local curTar = getClosest(cam.CFrame)
        local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
        ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
        if (ssHeadPoint - zz).Magnitude < fov then
            workspace.CurrentCamera.CFrame = CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position)
        end
    end
   
    if UserInputService:IsKeyDown(Enum.KeyCode.Up) then
        if (workspace.PlayersFolder:FindFirstChild(LocalPlayer.Name)) then
            workspace.PlayersFolder[LocalPlayer.Name].HumanoidRootPart.CFrame = CFrame.new(workspace.PlayersFolder[LocalPlayer.Name].HumanoidRootPart.Position + Vector3.new(0,3,0))
        end
    end


    if UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
        for i,v in pairs(game:GetService('CoreGui'):GetChildren()) do
            if (v.Name == 'Revenant') then
                v.Topbar.Visible = not v.Topbar.Visible
            end
        end
    end

    
end)

while wait() do
    for i,v in pairs(Players:GetPlayers()) do
        if (ESPtog) then
            if (v ~= LocalPlayer and Players[v.Name].Team ~= LocalPlayer.Team and v.Character ~= nil) then
                highlighter:create(v.Character, fillcolor, fillt, outlineColor) 
            end    
        end
        
    end

    if (map~=nil and bartog) then
        for i,v in pairs(map:GetChildren()) do
            game:GetService("ReplicatedStorage").GameEvents.BarricadeUpdate:FireServer(v)
        end
    end
end
