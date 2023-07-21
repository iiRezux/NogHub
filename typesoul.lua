repeat wait() until game:IsLoaded()

for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Nog hub" then
        v:Destroy()
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()

local venyx = library.new("Nog hub", 5013109572)

--Main Variables
local Self = game:GetService("Players").LocalPlayer
local TweenTPSpeed

--Local Connections
local JumpPowerConnection;
local AntiStunConnection;

--Main functions
local function char_valid()
    if Self.Character ~= nil then
        if Self.Character:FindFirstChild("HumanoidRootPart") then
            if Self.Character:FindFirstChild("Humanoid") then
                return true
            end
        end
    end
end

local function no_clip()
    if char_valid() then
        for i,v in pairs(Self.Character:GetChildren()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end

local function no_stun() --Attachment
    if char_valid() then
        for i,v in pairs(Self.Character.HumanoidRootPart:GetDescendants()) do
            if v.Name == "Attachment" or v.Name == "BodyFrontAttachment" then
                v:Destroy()
            end
        end
        for i,v in pairs(Self.Character.Head:GetDescendants()) do
            if v.Name == "BodyVelocity" then
                v:Destroy()
            end
        end
    end
end

-- themes
local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- first page
local page = venyx:addPage("Player", 5012544693)
local walkspeedsection = page:addSection("Walkspeed")
local jumppowersection = page:addSection("JumpPower")

--Variables
local WalkSpeedToggle;
local WalkSpeedSpeed;
local JumpPowerToggle;
local JumpPowerHeight;

walkspeedsection:addToggle("Walk Speed", nil, function(value)
    WalkSpeedToggle = value
    if WalkSpeedToggle == false then
        if char_valid() then
            Self.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

walkspeedsection:addSlider("Speed", 0, 16, 500, function(value)
    WalkSpeedSpeed = value
end)

spawn(function()
    while wait() do
        if WalkSpeedToggle and WalkSpeedSpeed ~= nil then
            if char_valid() then
                Self.Character.Humanoid.WalkSpeed = WalkSpeedSpeed
            end
        end
    end
end)

function Action(Object, Function) 
    if Object ~= nil then 
        Function(Object); 
    end 
end

jumppowersection:addToggle("Infinite Jump", nil, function(value)
    JumpPowerToggle = value
    if JumpPowerConnection == nil and JumpPowerToggle then
        JumpPowerConnection = game:GetService('UserInputService').InputBegan:connect(function(UserInput)
            if JumpPowerToggle then
                pcall(function()
                    if UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.Space then
                        if char_valid() then
                            Action(Self.Character.Humanoid, function(selft)
                                if selft:GetState() == Enum.HumanoidStateType.Jumping or selft:GetState() == Enum.HumanoidStateType.Freefall then
                                    Action(selft.Parent.HumanoidRootPart, function(selfr)
                                        if JumpPowerToggle then
                                            selfr.Velocity = Vector3.new(0, JumpPowerHeight, 0);
                                        end
                                    end)
                                end
                            end)
                        end
                    end
                end)
            end
        end)
    end
end)

jumppowersection:addSlider("Force", 50, 50, 500, function(value)
    JumpPowerHeight = value
end)

local autofarmsection = page:addSection("Auto Farm")

local currentNPC;
local autofarmnpctoggle;

autofarmsection:addDropdown("Select Mob", {"Fishbone","Menos","Frisker","Shinigami"}, function(v)
    currentNPC = v
end)

autofarmsection:addToggle("Auto Farm NPC", nil, function(value)
    autofarmnpctoggle = value
    if autofarmnpctoggle == false then
        if char_valid() then
            if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") then
                Self.Character.HumanoidRootPart.TweenHelp:Destroy()
            end
        end
    end
end)

local FarmOffset = Vector3.new(0, 0, 0)

autofarmsection:addSlider("Farm Offset", 0, -70, 70, function(value)
    FarmOffset = Vector3.new(0, value, 0)
end)

local rotationVal = 90

autofarmsection:addSlider("Farm Offset", 0, -180, 180, function(value)
    rotationVal = value
end)

local antisection = page:addSection("Anti Section")
local AntiStunToggle;

antisection:addToggle("Anti Stun", nil, function(value)
    AntiStunToggle = value
    game:GetService("RunService").RenderStepped:Connect(function()
        if AntiStunToggle then
            no_stun()
        end
    end)
end)

local function get_nearest_npc()
    local dist = math.huge
    local npc = nil
    for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
        if string.find(v.Name, currentNPC) then
            if char_valid() then
                if v:FindFirstChild("HumanoidRootPart") then
                    local distance = (Self.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
                    if distance < dist then
                        dist = distance
                        npc = v
                    end
                end
            end
        end
    end
    return npc
end

local target_npc;

spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if autofarmnpctoggle then
            if currentNPC ~= nil then
                if char_valid() then
                    if target_npc == nil then
                        if char_valid() then
                            if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") then
                                Self.Character.HumanoidRootPart.TweenHelp:Destroy()
                            end
                        end
                        if get_nearest_npc() ~= nil then
                            target_npc = get_nearest_npc()
                        end
                    elseif target_npc ~= nil then
                        if target_npc:FindFirstChild("Humanoid") then
                            if target_npc.Humanoid.Health <= 0 then
                                target_npc = nil
                            else
                                spawn(function()
                                    no_clip()
                                    no_stun()
                                    if char_valid() then
                                        Self.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                                        if Self.Character.HumanoidRootPart.Size ~= Vector3.new(50, 50, 50) then
                                            Self.Character.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                            Self.Character.HumanoidRootPart.CanCollide = false
                                            Self.Character.HumanoidRootPart.Transparency = 1
                                        end
                                    end
                                end)
                                if (Self.Character.HumanoidRootPart.Position - target_npc.HumanoidRootPart.Position).magnitude < 15 then
                                    Self.Character.HumanoidRootPart.CFrame = CFrame.new(target_npc.HumanoidRootPart.Position + FarmOffset) * CFrame.Angles(math.rad(rotationVal), 0, 0)
                                else
                                    local adjustoffset = CFrame.new(target_npc.HumanoidRootPart.Position + FarmOffset) * CFrame.Angles(math.rad(rotationVal), 0, 0)
                                    local tweenservice = game:GetService("TweenService")
                                    local duration = (Self.Character.HumanoidRootPart.Position - target_npc.HumanoidRootPart.Position).magnitude / TweenTPSpeed
                                    local tween = tweenservice:Create(Self.Character.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = adjustoffset })
                                    if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") == nil then
                                        local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                                        bodv.Name = "TweenHelp"
                                        bodv.Velocity = Vector3.new(0,0,0)
                                        bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                                    end
                                    tween:Play()
                                end
                            end
                        else
                            target_npc = nil
                        end
                    end
                end
            end
        end
    end)
end)

local teleportPage = venyx:addPage("Teleport")
local instantp = teleportPage:addSection("Instant TP")
local TPStatus;

instantp:addDropdown("Teleport to world", {"Las Noches", "Spawn Box"}, function(v)
    if v == "Las Noches" then
        if game:GetService("Workspace"):FindFirstChild("LasNoches") then
            if game.Workspace.LasNoches:FindFirstChild("MenosPit") then
                if char_valid() then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.LasNoches.MenosPit.CFrame
                end
            end
        end
    end
    if v == "Spawn Box" then
        if game:GetService("Workspace"):FindFirstChild("SpawnBox") then
            if game.Workspace.SpawnBox:FindFirstChild("TPbutton") then
                game:GetService("RunService").RenderStepped:Connect(function()
                    if TPStatus then
                        if char_valid() then
                            no_clip()
                        end
                    end
                end)
                local adjustoffset = game.Workspace.SpawnBox.TPbutton.CFrame
                local tweenservice = game:GetService("TweenService")
                local duration = (Self.Character.HumanoidRootPart.Position - game.Workspace.SpawnBox.TPbutton.Position).magnitude / TweenTPSpeed
                local tween = tweenservice:Create(Self.Character.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = adjustoffset })
                tween:Play()
                tween.Completed:Connect(function()
                    TPStatus = false
                end)
            end
        end
    end
end)

local settingsPage = venyx:addPage("Settings", 5012544693)
local teleportSpeed = settingsPage:addSection("Teleport Options")

TweenTPSpeed = 150

teleportSpeed:addSlider("Tween Speed", 150, 50, 500, function(v)
    TweenTPSpeed = v
end)

venyx:SelectPage(venyx.pages[1], true)
