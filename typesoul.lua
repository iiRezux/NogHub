repeat wait() until game:IsLoaded()

for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Nog hub" then
        v:Destroy()
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local Players = game:GetService("Players")
local ESP = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ESP-Library-9570", true))("there are cats in your walls let them out let them out let them out")

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

local hipheightsection = page:addSection("Hip Height")

local hipHeightToggle;
local hipheightheightvalue;

hipheightsection:addToggle("Hip Height", nil, function(value)
    hipHeightToggle = value
    if hipHeightToggle == false then
        if char_valid() then
            if Self.Character.Humanoid.HipHeight ~= 0 then
                Self.Character.Humanoid.HipHeight = 0
            end
        end
    end
end)

hipheightsection:addSlider("Height", 0, 0, 500, function(value)
    hipheightheightvalue = value
end)

spawn(function()
    while wait() do
        if hipHeightToggle and hipheightheightvalue ~= nil then
            if char_valid() then
                if Self.Character.Humanoid.HipHeight ~= hipheightheightvalue then
                    Self.Character.Humanoid.HipHeight = hipheightheightvalue
                end
            end
        end
    end
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

local NoClipToggle;

antisection:addToggle("No clip", nil, function(v)
    NoClipToggle = v
end)


local FastSwingToggle;
local oldComboTimer;

antisection:addToggle("Fast Swing", nil, function(v)
    FastSwingToggle = v
    if v then
        if char_valid() then
            oldComboTimer = Self.Character:GetAttribute("ComboTimer")
        else
            spawn(function()
                while wait() do 
                    if char_valid() then
                        oldComboTimer = Self.Character:GetAttribute("ComboTimer")
                        break
                    end
                end
            end)
        end
    end
end)


spawn(function()
    while wait() do
        if NoClipToggle then
            if char_valid() then
                no_clip()
            end
        end
    end
end)

spawn(function()
    while wait() do
        if FastSwingToggle then
            if char_valid() then
                Self.Character:SetAttribute("Combo", 2)
                if oldComboTimer ~= nil then
                    Self.Character:SetAttribute("ComboTimer", oldComboTimer)
                end
            end
        end
    end
end)

local autofarmpage = venyx:addPage("Farm", 5012544693)

local autofarmsection = autofarmpage:addSection("Auto Farm")

local currentNPC;
local autofarmnpctoggle;

autofarmsection:addDropdown("Select Mob", {"Fishbone","Menos","Adjuchas","Frisker","Shinigami"}, function(v)
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

autofarmsection:addSlider("Rotation", 0, -180, 180, function(value)
    rotationVal = value
end)

local function get_nearest_npc()
    local dist = math.huge
    local npc = nil
    for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
        if string.find(v.Name, currentNPC) then
            if char_valid() then
                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    if v.Humanoid.Health > 0 then
                        local distance = (Self.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
                        if distance < dist then
                            dist = distance
                            npc = v
                        end
                    end
                end
            end
        end
    end
    return npc
end

local target_npc;
local autoEatSoulToggle;
local eatingSoulState;
local autoEatSoulRange;
local function Auto_Attack(typer)
    if typer == "M1" then
        game:GetService('VirtualInputManager'):SendMouseButtonEvent(10, 10, 0, true, game, 0)
        game:GetService('VirtualInputManager'):SendMouseButtonEvent(10, 10, 0, false, game, 0)
    elseif typer == "Critical" then
        local virtualUser = game:GetService('VirtualUser')
        virtualUser:CaptureController()
        virtualUser:SetKeyDown('0x72')
        wait(0.2)
        virtualUser:SetKeyUp('0x72')
    end
end

local attackTypeChoosen;

spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if autofarmnpctoggle then
            if currentNPC ~= nil then
                if char_valid() then
                    if target_npc == nil then
                        spawn(function()
                            if char_valid() then
                                if Self.Character.Humanoid.HipHeight ~= 0 then
                                    Self.Character.Humanoid.HipHeight = 0
                                end
                                for i,v in pairs(Self.Character:GetChildren()) do
                                    if v:IsA("BasePart") and v.CanCollide == false then
                                        v.CanCollide = true
                                    end
                                end
                                if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") then
                                    Self.Character.HumanoidRootPart.TweenHelp:Destroy()
                                end
                            end
                        end)
                        if get_nearest_npc() ~= nil then
                            target_npc = get_nearest_npc()
                        end
                    elseif target_npc ~= nil then
                        if target_npc ~= get_nearest_npc() then
                            target_npc = nil
                            return
                        end
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
                                    spawn(function()
                                        Auto_Attack(attackTypeChoosen)
                                    end)
                                else
                                    if eatingSoulState ~= true then
                                        local adjustoffset = CFrame.new(target_npc.HumanoidRootPart.Position + FarmOffset) * CFrame.Angles(math.rad(rotationVal), 0, 0)
                                        local tweenservice = game:GetService("TweenService")
                                        local duration = (Self.Character.HumanoidRootPart.Position - target_npc.HumanoidRootPart.Position).magnitude / TweenTPSpeed
                                        local tween = tweenservice:Create(Self.Character.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = adjustoffset })
                                        if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") == nil then
                                            local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                                            bodv.Name = "TweenHelp"
                                            bodv.Velocity = Vector3.new(0,0,0)
                                            bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                                            bodv.P = 1000
                                        end
                                        tween:Play()
                                    end
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

local autoattacksectino = autofarmpage:addSection("Auto Attack")

autoattacksectino:addDropdown("Attack type", {"M1", "Critical"}, function(v)
    attackTypeChoosen = v
end)


local bodypartsection = autofarmpage:addSection("Auto Eat")

bodypartsection:addToggle("Auto Eat BodyParts", nil , function(v)
    autoEatSoulToggle = v
end)

autoEatSoulRange = 300

bodypartsection:addSlider("Eat Range", 300, 50, 1000 , function(v)
    autoEatSoulRange = v
end)

local function check_soul_in_table(npc, soultable)
    for i2, v2 in pairs(soultable) do
        if npc == v2 then
            return true
        end
    end
end

local function filter_closest(thetable)
    local dist = math.huge
    local closest;
    for i,v in pairs(thetable) do
        if char_valid() then
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health == 0 then
                local magn = (Self.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
                if magn < dist then
                    dist = magn
                    closest = v
                end
            end
        end
    end
    return closest
end

local function tweentopos(pos)
    local tweenservice = game:GetService("TweenService")
    local duration = (Self.Character.HumanoidRootPart.Position - pos).magnitude / TweenTPSpeed
    local tween = tweenservice:Create(Self.Character.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = CFrame.new(pos) })
    tween:Play()
end

local currentSoulsNearby = {}
local closest_body_part;

spawn(function()
    while wait() do
        if autoEatSoulToggle then
            for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Humanoid.Health == 0 then
                        if char_valid() then
                            if (Self.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude <= autoEatSoulRange then
                                if check_soul_in_table(v, currentSoulsNearby) ~= true then
                                    table.insert(currentSoulsNearby, v)
                                else
                                    if closest_body_part == nil then
                                        spawn(function()
                                            eatingSoulState = false
                                            if Self.Character.HumanoidRootPart:FindFirstChild("TweenEatHelp") then
                                                Self.Character.HumanoidRootPart.TweenEatHelp:Destroy()
                                            end
                                            for i,v in pairs(Self.Character:GetChildren()) do
                                                if v:IsA("BasePart") and v.CanCollide == false then
                                                    v.CanCollide = true
                                                end
                                            end
                                        end)
                                        if filter_closest(currentSoulsNearby) ~= nil then
                                            closest_body_part = filter_closest(currentSoulsNearby)
                                        end
                                    elseif closest_body_part ~= nil then
                                        if closest_body_part:FindFirstChild("HumanoidRootPart") ~= nil and closest_body_part:FindFirstChild("Humanoid") and closest_body_part.Humanoid.Health == 0 then
                                            eatingSoulState = true
                                            if (Self.Character.HumanoidRootPart.Position - closest_body_part.HumanoidRootPart.Position).magnitude > 6 then
                                                spawn(function()
                                                    no_clip()
                                                    if Self.Character.HumanoidRootPart:FindFirstChild("TweenEatHelp") == nil then
                                                        local bocv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                                                        bocv.Name = "TweenEatHelp"
                                                        bocv.Velocity = Vector3.new(0,0,0)
                                                        bocv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                                        bocv.P = 1000
                                                    end
                                                end)
                                                tweentopos(closest_body_part.HumanoidRootPart.Position)
                                            else
                                                if Self.Character.HumanoidRootPart:FindFirstChild("TweenEatHelp") then
                                                    Self.Character.HumanoidRootPart.TweenEatHelp:Destroy()
                                                end
                                                spawn(function()
                                                    local virtualUser = game:GetService('VirtualUser')
                                                    virtualUser:CaptureController()
                                                    virtualUser:SetKeyDown('0x62')
                                                    wait(0.2)
                                                    virtualUser:SetKeyUp('0x62')
                                                end)
                                            end
                                        else
                                            closest_body_part = nil
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local teleportPage = venyx:addPage("Teleport")
local instantp = teleportPage:addSection("Instant TP")
local tweentp = teleportPage:addSection("Tween TP")
local TPStatus;
local TPInsantSelected;

instantp:addDropdown("Teleport to world", {"Las Noches"}, function(v)
    TPInsantSelected = v
end)

instantp:addButton("Teleport", function()
    if TPInsantSelected ~= nil then
        if TPInsantSelected == "Las Noches" then
            if game:GetService("Workspace"):FindFirstChild("LasNoches") then
                if game.Workspace.LasNoches:FindFirstChild("MenosPit") then
                    if char_valid() then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.LasNoches.MenosPit.CFrame
                    end
                end
            end
        end
    end
end)

local AreasMueco = {
    ["Obby Spawn"] = CFrame.new(-7883.24316, 4576.62988, 362.419495),
    ["Obby End"] = CFrame.new(-7831.18457, 4574.43066, -235.559998)
}

tweentp:addDropdown("Teleport to area", {"Obby Spawn", "Obby End"}, function(option)
    for i,v in pairs(AreasMueco) do
        if i == option then
            if char_valid() then
                local tweenservice = game:GetService("TweenService")
                local duration = (Self.Character.HumanoidRootPart.Position - Vector3.new(v.X, v.Y, v.Z)).magnitude / TweenTPSpeed
                local tween = tweenservice:Create(Self.Character.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = v })
                if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") == nil then
                    local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                    bodv.Name = "TweenHelp"
                    bodv.Velocity = Vector3.new(0,0,0)
                    bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                end
                tween:Play()
                tween.Completed:Connect(function()
                    if char_valid() then
                        if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") then
                            Self.Character.HumanoidRootPart.TweenHelp:Destroy()
                        end
                    end
                end)
            end
        end
    end
end)

local visualPage = venyx:addPage("Visual", 5012544693)
local espSection = visualPage:addSection("ESP")

espSection:addToggle("Player ESP", nil, function(v)
    ESP.Enabled = v
    if v then
        for i, Player in next, Players:GetPlayers() do
            if Player ~= game.Players.LocalPlayer then
                if Player.Character ~= nil then
                    ESP.Object:New(ESP:GetCharacter(Player))
                    ESP:CharacterAdded(Player):Connect(function(Character)
                        ESP.Object:New(Character)
                    end)
                end
            end
         end
         
         Players.PlayerAdded:Connect(function(Player)
            if Player.Character ~= nil then
                ESP.Object:New(ESP:GetCharacter(Player))
                ESP:CharacterAdded(Player):Connect(function(Character)
                    ESP.Object:New(Character)
                end)
            end
         end)
    end
end)

local settingsPage = venyx:addPage("Settings", 5012544693)
local teleportSpeed = settingsPage:addSection("Teleport Options")

TweenTPSpeed = 150

teleportSpeed:addSlider("Tween Speed", 150, 50, 500, function(v)
    TweenTPSpeed = v
end)


venyx:SelectPage(venyx.pages[1], true)
