repeat wait() until game:IsLoaded()

for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Nog hub" then
        v:Destroy()
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local Players = game:GetService("Players")
local ESP = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ESP-Library-9570", true))("there are cats in your walls let them out let them out let them out")

ESP.Settings.Tracers.Enabled = false
ESP.Settings.Boxes.Enabled = false

local venyx = library.new("Nog hub", 5013109572)

--Main Variables
local Self = game:GetService("Players").LocalPlayer
local TweenTPSpeed

--Local Connections
local JumpPowerConnection;

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

local function Tween_Call(Pos, Offset, Rotation, tweenstore)
    local Offset = Offset or Vector3.new(0,0,0)
    local Rotation = Rotation or 0

    local adjustoffset = CFrame.new(Pos + Offset) * CFrame.Angles(math.rad(Rotation), 0, 0)
    local tweenservice = game:GetService("TweenService")
    local duration;
    duration = (Self.Character.HumanoidRootPart.Position - Pos + Offset).magnitude / TweenTPSpeed
    local tween = tweenservice:Create(Self.Character.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = adjustoffset })
    tween:Play()
    if tweenstore then
        if type(tweenstore) == "table" then
            table.insert(tweenstore, tween)
            tween.Completed:Connect(function()
                for i,v in pairs(tweenstore) do
                    if v == tween then
                        tweenstore[i] = nil
                    end
                end
            end)
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

local function create_esp(theparent, distance)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_Nog"
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 70, 0, 20)
    billboardGui.Parent = theparent
    billboardGui.Enabled = false

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NameLabel"
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    if not distance then
        textLabel.Text = "Mission"
    else
        textLabel.Text = "Mission\nmeters"
    end
    textLabel.TextColor3 = Color3.fromRGB(255, 51, 51)
    textLabel.TextScaled = false
    textLabel.Parent = billboardGui
    textLabel.Font = Enum.Font.Jura
    textLabel.FontSize = 'Size12'
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Top

    local uistroke = Instance.new("UIStroke", textLabel)
    uistroke.Thickness = 0.5
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

hipheightsection:addSlider("Height", 4, 4, 500, function(value)
    hipheightheightvalue = value
    if hipheightheightvalue == 4 then
        hipheightheightvalue = 4.099999
    end
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
local choosenDodgeRange;
local AutoDodgeCeroConnection;
local AutoDodgeCeroToggle;
local AntiStunToggle;

antisection:addToggle("Auto Dodge Cero", nil, function(value)
    AutoDodgeCeroToggle = value
    if AutoDodgeCeroConnection == nil and AutoDodgeCeroToggle then
        AutoDodgeCeroConnection = game:GetService("Workspace").Effects.DescendantAdded:Connect(function(effect)
            if AutoDodgeCeroToggle then
                if char_valid() then
                    if effect:IsA("Model") then
                        if string.find("Cero", effect.Name) then
                            local part = effect:FindFirstChild("Beam")
                            if part then
                                if (Self.Character.HumanoidRootPart.Position - part.Position).magnitude <= choosenDodgeRange then
                                    if effect.Parent.Name ~= Self.Name then
                                        local oldhip = Self.Character.Humanoid.HipHeight
                                        Self.Character.Humanoid.HipHeight = oldhip + part.Size.Y + 5
                                        wait(1)
                                        Self.Character.Humanoid.HipHeight = oldhip
                                    else
                                        print(part.Size.X,part.Size.Y, part.Size.Z)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while wait() do
        if AutoDodgeCeroToggle then
            if choosenDodgeRange ~= nil then
                for i,v in pairs(game:GetService("Workspace").Effects:GetDescendants()) do
                    if v:IsA("Model") and string.find("Cero", v.Name) then
                        if v.Parent.Name ~= Self.Name then
                            if v:FindFirstChild("Beam") then
                                if (Self.Character.HumanoidRootPart.Position - v.Beam.Position).magnitude <= choosenDodgeRange then
                                    if Self.Character.Humanoid.HipHeight ~= 350 then
                                        Self.Character.Humanoid.HipHeight = 350
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

choosenDodgeRange = 40

antisection:addSlider("Cero range", 40, 10, 150, function(v)
    choosenDodgeRange = v
end)

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
            for i,v in pairs(Self.Character:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide == false then
                    v.CanCollide = true
                end
            end
        end
    end
end)

local FarmOffset = Vector3.new(0, 0, 0)

autofarmsection:addSlider("Farm Offset", 0, -70, 70, function(value)
    FarmOffset = Vector3.new(0, value, 0)
end)

local rotationVal = 0

autofarmsection:addSlider("Rotation", 0, -180, 180, function(value)
    rotationVal = value
end)

local MobRangeAutoFarm = 10000

autofarmsection:addSlider("Mob Range", 10000, 50, 10000, function(v)
    MobRangeAutoFarm = v
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

local function check_valibilaty(npc)
    for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
        if npc == v then
            return v
        end
    end
end

local target_npc;
spawn(function() --Nearest Config
    while wait() do
        if autofarmnpctoggle then
            if char_valid() then
                if target_npc == nil then
                    if get_nearest_npc() ~= nil then
                        if (Self.Character.HumanoidRootPart.Position - get_nearest_npc().HumanoidRootPart.Position).magnitude < MobRangeAutoFarm then
                            target_npc = get_nearest_npc()
                        end
                    end
                else
                    if get_nearest_npc() == nil then
                        target_npc = nil
                    else
                        if check_valibilaty(target_npc) ~= nil then
                            if check_valibilaty(target_npc):FindFirstChild("HumanoidRootPart") == nil or check_valibilaty(target_npc):FindFirstChild("Humanoid") == nil then
                                target_npc = nil
                            else
                                if check_valibilaty(target_npc).Humanoid.Health == 0 or (Self.Character.HumanoidRootPart.Position - get_nearest_npc().HumanoidRootPart.Position).magnitude > MobRangeAutoFarm then
                                    target_npc = nil
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)
local autoEatSoulToggle;
local eatingSoulState;
local autoEatSoulRange;
local function Auto_Attack(typer)
    if typer == "M1" or typer == nil then
        local A_1 = "LightAttack"
        local Event = game:GetService("ReplicatedStorage").Remotes.ServerCombatHandler
        Event:FireServer(A_1)
        wait(0.4)
    elseif typer == "Critical" then
        local virtualUser = game:GetService('VirtualUser')
        virtualUser:CaptureController()
        virtualUser:SetKeyDown('0x72')
        wait(0.8)
        virtualUser:SetKeyUp('0x72')
    end
end

local attackTypeChoosen;
local currentTween = {}

spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if autofarmnpctoggle then
            if currentNPC ~= nil then
                if char_valid() then
                    if target_npc ~= nil then
                        if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") == nil then
                            local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                            bodv.Name = "TweenHelp"
                            bodv.Velocity = Vector3.new(0,0,0)
                            bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                            bodv.P = 1000
                        end
                        if (Self.Character.HumanoidRootPart.Position - target_npc.HumanoidRootPart.Position).magnitude <= 70 and eatingSoulState ~= true then
                            Auto_Attack(attackTypeChoosen)
                        end
                        if char_valid() then
                            Self.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                            no_clip()
                            no_stun()
                        end
                        if eatingSoulState ~= true then
                            if target_npc ~= nil then
                                if (Self.Character.HumanoidRootPart.Position - target_npc.HumanoidRootPart.Position).magnitude < 15 then
                                    if #currentTween ~= 0 then
                                        for i,v in pairs(currentTween) do
                                            v:Cancel()
                                            v:Destroy()
                                        end
                                    end
                                    Self.Character.HumanoidRootPart.CFrame = CFrame.new(target_npc.HumanoidRootPart.Position + FarmOffset) * CFrame.Angles(math.rad(rotationVal), 0, 0)
                                else
                                    Tween_Call(target_npc.HumanoidRootPart.Position, FarmOffset, rotationVal, currentTween)
                                end
                            end
                        end
                    else
                        if char_valid() then
                            if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelp") then
                                Self.Character.HumanoidRootPart.TweenHelp:Destroy()
                            end
                            for i,v in pairs(Self.Character:GetChildren()) do
                                if v:IsA("BasePart") and v.CanCollide == false then
                                    v.CanCollide = true
                                end
                            end
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
    if autoEatSoulToggle == false then
        eatingSoulState = false
        if char_valid() then
            if Self.Character.HumanoidRootPart:FindFirstChild("TweenEatHelp") then
                Self.Character.HumanoidRootPart.TweenEatHelp:Destroy()
            end
        end
    end
end)

autoEatSoulRange = 300

bodypartsection:addSlider("Eat Range", 300, 50, 10000 , function(v)
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

local function click_b()
    local virtualUser = game:GetService('VirtualUser')
    virtualUser:CaptureController()
    virtualUser:SetKeyDown('0x62')
    wait(0.2)
    virtualUser:SetKeyUp('0x62')
end

local currentSoulsNearby = {}
local closest_body_part;

spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
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
                                        eatingSoulState = false
                                        if char_valid() then
                                            if Self.Character.HumanoidRootPart:FindFirstChild("TweenEatHelp") then
                                                Self.Character.HumanoidRootPart.TweenEatHelp:Destroy()
                                            end
                                            for i,v in pairs(Self.Character:GetChildren()) do
                                                if v:IsA("BasePart") and v.CanCollide == false then
                                                    v.CanCollide = true
                                                end
                                            end
                                            if filter_closest(currentSoulsNearby) ~= nil then
                                                closest_body_part = filter_closest(currentSoulsNearby)
                                            end
                                        end
                                    elseif closest_body_part ~= nil then
                                        if closest_body_part:FindFirstChild("HumanoidRootPart") ~= nil and closest_body_part:FindFirstChild("Humanoid") and closest_body_part.Humanoid.Health == 0 then
                                            eatingSoulState = true
                                            if (Self.Character.HumanoidRootPart.Position - closest_body_part.HumanoidRootPart.Position).magnitude > 15 then
                                                if char_valid() then
                                                    no_clip()
                                                    if Self.Character.HumanoidRootPart:FindFirstChild("TweenEatHelp") == nil then
                                                        local bocv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                                                        bocv.Name = "TweenEatHelp"
                                                        bocv.Velocity = Vector3.new(0,0,0)
                                                        bocv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                                        bocv.P = 1000
                                                    end
                                                    Tween_Call(closest_body_part.HumanoidRootPart.Position)
                                                end
                                            else
                                                if Self.Character.HumanoidRootPart:FindFirstChild("TweenEatHelp") then
                                                    Self.Character.HumanoidRootPart.TweenEatHelp:Destroy()
                                                end
                                                click_b()
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
    end)
end)

local autocompleteminigamSection = autofarmpage:addSection("Auto Complete Minigame")

local MiniGameOsuToggle;

autocompleteminigamSection:addToggle("Divison Duties", nil , function(v)
    MiniGameOsuToggle = v
end)

local raidsection = autofarmpage:addSection("Raid")

local AutoPickUpFlag;

raidsection:addToggle("Auto Pick-up Flag", nil , function(v)
    AutoPickUpFlag = v
end)

local ChoosenFlagType;

raidsection:addDropdown("Choose Flag", {"Arrancar", "Quincy", "Shinigami"}, function(v)
    ChoosenFlagType = v
end)

spawn(function()
    while wait() do
        if AutoPickUpFlag then
            if char_valid() then
                if game:GetService("Workspace"):FindFirstChild("KarakuraRaid") then
                    if game:GetService("Workspace").KarakuraRaid:FindFirstChild(ChoosenFlagType.."Flag") then
                        if game:GetService("Workspace").KarakuraRaid[ChoosenFlagType.."Flag"]:FindFirstChild("ClickDetector") then
                            if char_valid() then
                                for i,v in pairs(game:GetService("Workspace").KarakuraRaid[ChoosenFlagType.."Flag"]:GetDescendants()) do
                                    if v:IsA("Part") then
                                        if (Self.Character.HumanoidRootPart.Position - v.Position).magnitude <= 16 then
                                            fireclickdetector(game:GetService("Workspace").KarakuraRaid[ChoosenFlagType.."Flag"].ClickDetector)
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

local AutoTweenToFlag;
local FlagTweenOffset;
local StoredFlagTweens;

raidsection:addToggle("Auto Tween to Flag", nil , function(v)
    AutoTweenToFlag = v
end)

FlagTweenOffset = Vector3.new(0, -6, 0)

raidsection:addSlider("Offset", -6, -15, 15 , function(v)
    FlagTweenOffset = Vector3.new(0, v, 0)
end)

spawn(function()
    while wait() do
        if AutoTweenToFlag then
            if char_valid() then
                if game:GetService("Workspace"):FindFirstChild("KarakuraRaid") then
                    if game:GetService("Workspace").KarakuraRaid:FindFirstChild(ChoosenFlagType.."Flag") then
                        for i,v in pairs(game:GetService("Workspace").KarakuraRaid[ChoosenFlagType.."Flag"]:GetDescendants()) do
                            if v:IsA("Part") then
                                if (Self.Character.HumanoidRootPart.Position - v.Position).magnitude < 12 then
                                    if #StoredFlagTweens ~= 0 then
                                        for i2,v2 in pairs(StoredFlagTweens) do
                                            v2:Cancel()
                                            v2:Destroy()
                                        end
                                    end
                                    no_clip()
                                    no_stun()
                                    if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpFlga") == nil then
                                        local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                                        bodv.Name = "TweenHelpFlga"
                                        bodv.Velocity = Vector3.new(0,0,0)
                                        bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                                        bodv.P = 1000
                                    end
                                    Self.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position + FlagTweenOffset)
                                else
                                    no_clip()
                                    no_stun()
                                    if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpFlga") == nil then
                                        local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                                        bodv.Name = "TweenHelpFlga"
                                        bodv.Velocity = Vector3.new(0,0,0)
                                        bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                                        bodv.P = 1000
                                    end
                                    Tween_Call(v.Position, FlagTweenOffset, StoredFlagTweens)
                                end
                            end
                        end
                    else
                        if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpFlga") then
                            Self.Character.HumanoidRootPart.TweenHelpFlga:Destroy()
                        end
                        for i,v in pairs(Self.Character:GetChildren()) do
                            if v:IsA("BasePart") and v.CanCollide == false then
                                v.CanCollide = true
                            end
                        end
                    end
                else
                    if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpFlga") then
                        Self.Character.HumanoidRootPart.TweenHelpFlga:Destroy()
                    end
                    for i,v in pairs(Self.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide == false then
                            v.CanCollide = true
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while wait() do
        if MiniGameOsuToggle then
            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
                if v.Name == "Division11Minigame" then
                    if v.Enabled == true then
                        for i2,v2 in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Division11Minigame:GetDescendants()) do
                            if v2:IsA("ImageButton") then
                                firesignal(v2.MouseButton1Click)
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
local missionTPSector = teleportPage:addSection("Mission TP")
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
                    bodv.P = 1000
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

local currentTweening;

missionTPSector:addButton("Tween to nearest mission", function(v)
    local dist = math.huge;
    local nearest_mission;
    for i,v in pairs(game:GetService("Workspace").NPCs.MissionNPC:GetChildren()) do
        if v.Name == "MissionBoard" then
            local part = v:FindFirstChildOfClass("Part")
            if char_valid() then
                local magn = (Self.Character.HumanoidRootPart.Position - part.Position).magnitude
                if magn < dist then
                    dist = magn
                    nearest_mission = part
                end
            end
        end
    end
    if nearest_mission ~= nil then
        if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpMissionTP") == nil then
            local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
            bodv.Name = "TweenHelpMissionTP"
            bodv.Velocity = Vector3.new(0,0,0)
            bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            bodv.P = 1000
        end
        Tween_Call(nearest_mission.Position, Vector3.new(0,0,0), 0, currentTweening)
        repeat wait() until currentTweening == nil
        if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpMissionTP") then
            Self.Character.HumanoidRootPart["TweenHelpMissionTP"]:Destroy()    
        end
    end
end)

local visualPage = venyx:addPage("Visual", 5012544693)
local espSection = visualPage:addSection("ESP Player")

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

--[[local ESPdroppedItemsSection = visualPage:addSection("Dropped Items ESP")

local droppedItemsESP;

ESPdroppedItemsSection:addToggle("Dropped Items ESP", nil, function(v)
    droppedItemsESP = v
    if droppedItemsESP then
        for i, v in pairs(game.Workspace.DroppedItems:GetChildren()) do
            if v:IsA("Part") then
                ESP.Object:New(v)
            end
        end
        ESP:AddListener(v.Parent):Connect(function(Character)
            ESP.Object:New(Character)
        end)
    end
end)]]

local missionItemsSection = visualPage:addSection("ESP Mission")

local function check_esp_exist(model)
    for i,v in pairs(model:GetDescendants()) do
        if v.Name == "ESP_Nog" then
            return true
        end
    end
end

local missionESPToggle;
local showDistanceMission;

missionItemsSection:addToggle("Mission ESP", nil, function(v22)
    missionESPToggle = v22
    if missionESPToggle then
        for i,v in pairs(game:GetService("Workspace").NPCs.MissionNPC:GetChildren()) do
            if v.Name == "MissionBoard" then
                if check_esp_exist(v) ~= true then
                    create_esp(v:FindFirstChildOfClass("Part"), showDistanceMission)
                    if missionESPToggle then
                        for i2,v2 in pairs(v:GetDescendants()) do
                            if v2.Name == "ESP_Nog" then
                                v2.Enabled = true
                            end
                        end
                    end
                elseif check_esp_exist(v) == true then
                    for i2,v2 in pairs(v:GetDescendants()) do
                        if v2.Name == "ESP_Nog" then
                            v2.Enabled = true
                        end
                    end
                end
            end
        end
    else
        for i,v in pairs(game:GetService("Workspace").NPCs.MissionNPC:GetDescendants()) do
            if v.Name == "ESP_Nog" then
                v.Enabled = false
            end
        end
    end
end)

spawn(function()
    while wait() do
        if missionESPToggle and showDistanceMission then
            if char_valid() then
                for i,v in pairs(game:GetService("Workspace").NPCs.MissionNPC:GetDescendants()) do
                    if v.Name == "NameLabel" and v.Parent.Name == "ESP_Nog" then
                        if v.TextScaled == false then
                            v.TextScaled = true
                        end
                        if v.Text ~= "Mission\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - v.Parent.Parent.Position).magnitude)).." meters" then
                            v.Text = "Mission\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - v.Parent.Parent.Position).magnitude)).." meters"
                        end
                    end
                end
            end
        elseif missionESPToggle and showDistanceMission ~= true then
            for i,v in pairs(game:GetService("Workspace").NPCs.MissionNPC:GetDescendants()) do
                if v.Name == "NameLabel" and v.Parent.Name == "ESP_Nog" then
                    if v.TextScaled == true then
                        v.TextScaled = false
                    end
                end
            end
        end
    end
end)

missionItemsSection:addToggle("Show distance", nil, function(v)
    showDistanceMission = v
end)

local espSettingsSector = visualPage:addSection("ESP Settings")

espSettingsSector:addSlider("Max Distance", 1000, 100, 10000, function(v)
    ESP.Settings.MaxDistance = v
end)

espSettingsSector:addToggle("Show Health", nil, function(v)
    ESP.Settings.Names.Health = v
end)

espSettingsSector:addToggle("Tracers", nil, function(v)
    ESP.Settings.Tracers.Enabled = v
end)

espSettingsSector:addToggle("Boxes", nil, function(v)
    ESP.Settings.Boxes.Enabled = v
end)

local settingsPage = venyx:addPage("Settings", 5012544693)
local teleportSpeed = settingsPage:addSection("Teleport Options")

TweenTPSpeed = 150

teleportSpeed:addSlider("Tween Speed", 150, 50, 500, function(v)
    TweenTPSpeed = v
end)


venyx:SelectPage(venyx.pages[1], true)
