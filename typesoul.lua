repeat wait() until game:IsLoaded()

for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Sinister Hub" then
        v:Destroy()
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Sinister Hub", 5013109572)

local PlaceIds = {
    ["Karakura"] = 14069678431,
    ["Hueco"] = 14069122388
}

local AllMobs = {
    ["Shinigami"] = "Shinigami",
    ["Frisker"] = "Frisker",
    ["Fishbone"] = "Fishbone",
    ["Jackal"] = "Adjuchas",
    ["Bawabawa"] = "Snake",
    ["Menos"] = "Menos",
    ["MissionFrisker"] = "Corrupt Frisker"
}

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

local rotationVal = 0

local function Tween_Call(Pos, Offset, Rotation, tweenstore)
    local Offset = Offset or Vector3.new(0,0,0)
    local Rotation = Rotation or 0
    local adjustoffset;

    if Rotation and Rotation == rotationVal then
        adjustoffset = CFrame.new(Pos + Offset) * CFrame.Angles(math.rad(rotationVal), 0, 0)
    else
        adjustoffset = CFrame.new(Pos + Offset) * CFrame.Angles(math.rad(Rotation), 0, 0)
    end
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
            if v.Name == "Attachment" or v.Name == "BodyFrontAttachment" or v.Name == "HollowPunch3" or v.Name == "Shards" or v.Name == "ExpLines" or v.Name == "Specs" or v.Name == "Spark" or v.Name == "HollowPunch1" or v.Name == "HollowPunch2" then
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

local AutoCampSection =  page:addSection("Auto Camp")

local AutoCampToggle;
local TeleportedAboveDid;
local AutoCampHealth = 5;

AutoCampSection:addToggle("Auto Camp (Beta)", nil, function(v)
    AutoCampToggle = v
    if v == false then
        if char_valid() then
            TeleportedAboveDid = false
            Self.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

AutoCampSection:addSlider("At Health (%)", 5, 0, 100, function(v)
    AutoCampHealth = v
end)

AutoCampSection:addButton("Get down", function()
    if TeleportedAboveDid == true then
        if char_valid() then
            TeleportedAboveDid = false
            Self.Character.HumanoidRootPart.Anchored = false
        end
    end
end)



spawn(function()
    while wait() do
        if AutoCampToggle then
            if char_valid() then
                local thehealth = (Self.Character.Humanoid.MaxHealth / 100) * AutoCampHealth
                if Self.Character.Humanoid.Health <= thehealth and TeleportedAboveDid ~= true then
                    TeleportedAboveDid = true
                    local OldCFrame = Self.Character.HumanoidRootPart.CFrame
                    Self.Character.HumanoidRootPart.CFrame = CFrame.new(Self.Character.HumanoidRootPart.Position + Vector3.new(0, 350, 0))
                    wait(0.2)
                    Self.Character.HumanoidRootPart.Anchored = true
                    spawn(function()
                        while wait() do
                            if TeleportedAboveDid == true and AutoCampToggle == true then
                                if char_valid() then
                                    wait(2)
                                    Self.Character.HumanoidRootPart.Anchored = false
                                    Self.Character.HumanoidRootPart.CFrame = OldCFrame
                                    wait(0.2)
                                    Self.Character.HumanoidRootPart.CFrame = CFrame.new(Self.Character.HumanoidRootPart.Position + Vector3.new(0, 300, 0))
                                    wait(0.2)
                                    Self.Character.HumanoidRootPart.Anchored = true
                                end
                            end
                        end
                    end)
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

antisection:addToggle("Auto Dodge Cero (Beta)", nil, function(value)
    AutoDodgeCeroToggle = value
    if AutoDodgeCeroConnection == nil and AutoDodgeCeroToggle then
        AutoDodgeCeroConnection = game:GetService("Workspace").Effects.DescendantAdded:Connect(function(effect)
            if AutoDodgeCeroToggle then
                if char_valid() then
                    if effect:IsA("Model") then
                        if string.find(effect.Name, "Cero") then
                            local part = effect:FindFirstChild("Beam")
                            if part then
                                if (Self.Character.HumanoidRootPart.Position - part.Position).magnitude <= choosenDodgeRange then
                                    if effect.Parent.Name ~= Self.Name then
                                        local oldhip = Self.Character.Humanoid.HipHeight
                                        Self.Character.Humanoid.HipHeight = oldhip + part.Size.Y + 20
                                        wait(1)
                                        Self.Character.Humanoid.HipHeight = oldhip
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

local miscsection = page:addSection("Misc")

local autoCreatePartyToggle;

miscsection:addToggle("Auto Create Party", nil, function(v)
    autoCreatePartyToggle = v
end)

miscsection:addButton("Redeem all codes", function()
    local currentcodes = loadstring(game:HttpGet("https://raw.githubusercontent.com/iiRezux/MiscS/main/typesoul.lua"))()
    if #currentcodes ~= 0 then
        if char_valid() then
            for i,v in pairs(currentcodes) do
                local A_1 = v
                local Event = Self.Character.CharacterHandler.Remotes.Codes
                Event:InvokeServer(A_1)
            end
        end
    end
end)

miscsection:addButton("Fast Reset", function()
    if char_valid() then
        Self.Character.Humanoid.Health = 0
    end
end)

spawn(function()
    while wait(1) do
        if autoCreatePartyToggle then
            if char_valid() then
                if Self:GetAttribute("Party") == nil then
                    local Event = Self.Character.CharacterHandler.Remotes.PartyCreate
                    Event:FireServer()
                else
                    if Self:GetAttribute("Party") == "" then
                        local Event = Self.Character.CharacterHandler.Remotes.PartyCreate
                        Event:FireServer()
                    end
                end
            end
        end
    end
end)

local autofarmpage = venyx:addPage("Farm", 5012544693)

local autofarmsection = autofarmpage:addSection("Auto Farm")

local currentNPC;
local autofarmnpctoggle;

autofarmsection:addDropdown("Select Mob", {"Fishbone","Menos", "Adjuchas","Frisker","Shinigami"}, function(v)
    if v ~= "Adjuchas" then
        currentNPC = v
    else
        currentNPC = "Jackal"
    end
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
                    if target_npc ~= nil and check_valibilaty(target_npc) and check_valibilaty(target_npc):FindFirstChild("HumanoidRootPart") then
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
                            if target_npc ~= nil and char_valid() then
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

local autoequipsection = autofarmpage:addSection("Auto Equip")

local autoEquipChoosen;
local autoEquipToggle;

autoequipsection:addToggle("Auto Equip", nil, function(v)
    autoEquipToggle = v
end)

autoequipsection:addDropdown("Tool", {"Zanpakuto"}, function(v)
    autoEquipChoosen = v
end)

spawn(function()
    while wait(1) do
        if autoEquipToggle then
            if autoEquipChoosen ~= nil then
                if char_valid() then
                    if Self.Character:FindFirstChild(autoEquipChoosen) then
                        local Event = Self.Character.CharacterHandler.Remotes.Weapon
                        Event:FireServer()
                    end
                end
            end
        end
    end
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

local raidsection = autofarmpage:addSection("Raid (Beta)")

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
                            if v:IsA("MeshPart") then
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
                                    Tween_Call(v.Position, FlagTweenOffset, 0, StoredFlagTweens)
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

instantp:addDropdown("Teleport to world", {"Soul Society", "Wanden" , "Hueco Mundo", "Las Noches"}, function(v)
    TPInsantSelected = v
end)

instantp:addButton("Teleport", function()
    if TPInsantSelected ~= nil then
        if TPInsantSelected == "Soul Society" then
            if game.PlaceId == PlaceIds["Karakura"] then
                if game:GetService("Workspace"):FindFirstChild("SoulGate") then
                    if game:GetService("Workspace").SoulGate:FindFirstChild("SoulGate") then
                        if char_valid() then
                            Self.Character.HumanoidRootPart.CFrame = game.Workspace.SoulGate.SoulGate.CFrame
                        end
                    end
                end
            end
        elseif TPInsantSelected == "Wanden" then
            if game.PlaceId == PlaceIds["Karakura"] then
                if game:GetService("Workspace"):FindFirstChild("WandenreichGate") then
                    if game:GetService("Workspace").WandenreichGate:FindFirstChildOfClass("Part") then
                        Self.Character.HumanoidRootPart.CFrame = game.Workspace.WandenreichGate:FindFirstChildOfClass("Part").CFrame
                    end
                end
            end
        elseif TPInsantSelected == "Hueco Mundo" then
            if game.PlaceId == PlaceIds["Karakura"] then
                if game:GetService("Workspace"):FindFirstChild("Pathway") then
                    if game:GetService("Workspace").Pathway:FindFirstChild("PortalBlock") then    
                        Self.Character.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Workspace").Pathway.PortalBlock.Position + Vector3.new(-3.5, 0, 0))
                    end
                end
            end
        end
        if TPInsantSelected == "Las Noches" then
            if game.PlaceId == PlaceIds["Hueco"] then
                if game:GetService("Workspace"):FindFirstChild("LasNoches") then
                    if game.Workspace.LasNoches:FindFirstChild("MenosPit") then
                        if char_valid() then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.LasNoches.MenosPit.CFrame
                        end
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

local TweenStoreNPC;

tweentp:addDropdown("Teleport to NPC", {"Harribel"}, function(v22)
    if v22 == "Harribel" then
        for i,v in pairs(game:GetService("Workspace").NPCs:GetDescendants()) do
            if v.Name == "Harribel's Cloak" then
                if char_valid() then
                    if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpNPC") == nil then
                        local bodv = Instance.new("BodyVelocity", Self.Character.HumanoidRootPart)
                        bodv.Name = "TweenHelpNPC"
                        bodv.Velocity = Vector3.new(0,0,0)
                        bodv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                        bodv.P = 1000
                    end
                    Tween_Call(v.Parent.HumanoidRootPart.Position, Vector3.new(4,0,0), 0, TweenStoreNPC)
                    repeat wait() until TweenStoreNPC ~= nil
                    TweenStoreNPC.Completed:Connect(function()
                        if char_valid() then
                            if Self.Character.HumanoidRootPart:FindFirstChild("TweenHelpNPC") then
                                Self.Character.HumanoidRootPart.TweenHelpNPC:Destroy()
                            end
                        end
                    end)
                end
            end
        end
    end
end)

local currentTweening;

missionTPSector:addButton("Tween to nearest mission", function(v)
    local dist = math.huge;
    local nearest_mission;
    if char_valid() then
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
    end
    if nearest_mission ~= nil then
       if char_valid() then
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
    end
end)

local visualPage = venyx:addPage("Visual", 5012544693)

local PlayerESPColorSelected = Color3.fromRGB(255, 51, 51)
local MobESPColorSelected = Color3.fromRGB(255, 51, 51)
local MissionESPColorSelected = Color3.fromRGB(255, 51, 51)

local PlayerESPToggle;
local ShowDistancePlayerESP;
local showHealthToggle;



local espSection = visualPage:addSection("ESP Player")

local function Is_Player(name)
    for i,v in pairs(game.Players:GetPlayers()) do
        if v.Name == name then
            return true
        end
    end
end


local ESPPlayerShowHealth = true
local ESPPlayerShowDistance = true
local PlayerESPColor = Color3.fromRGB(3, 231, 107)
local ESPMaxDistance = 1000

local c = workspace.CurrentCamera
local ps = game:GetService("Players")
local lp = ps.LocalPlayer
local rs = game:GetService("RunService")
local ESPPlayerToggle = false
local ESPPlayerMaxDistance = 10000;

local function esp(p,cr)
    local h = cr:WaitForChild("Humanoid")
    local hrp = cr:WaitForChild("HumanoidRootPart")

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true 
    text.Font = 2
    text.Color = PlayerESPColor
    text.Size = 13

    local c1
    local c2
    local c3
    local c4

    local function dc()
        text.Visible = false
        text:Remove()
        if c1 then
            c1:Disconnect()
            c1 = nil 
        end
        if c2 then
            c2:Disconnect()
            c2 = nil 
        end
        if c3 then
            c3:Disconnect()
            c3 = nil 
        end
        if c4 then
            c4:Disconnect()
            c4 = nil 
        end
    end

    c4 = game.workspace.Entities.ChildRemoved:Connect(function(b)
        if b == cr then
            dc()
        end
    end)

    c2 = h.Died:Connect(function()
        dc()
    end)

    c3 = h.HealthChanged:Connect(function(v)
        if (h:GetState() == Enum.HumanoidStateType.Dead) then
            dc()
        end
    end)

    c1 = rs.RenderStepped:Connect(function()
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)
        if hrp_onscreen and ESPPlayerToggle and char_valid() and (Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude <= ESPPlayerMaxDistance then
            text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
            text.Visible = true
            text.Color = PlayerESPColor
            if ESPPlayerShowDistance and ESPPlayerShowHealth ~= true then
                if char_valid() then
                    text.Text = p.Name.."\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude)).."m"
                else
                    text.Text = p.Name
                end
            elseif ESPPlayerShowDistance and ESPPlayerShowHealth then
                if char_valid() then
                    text.Text = p.Name.."\n["..math.floor(h.Health).."/"..h.MaxHealth.."]\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude)).."m"
                else
                    text.Text = p.Name
                end
            elseif ESPPlayerShowDistance ~= true and ESPPlayerShowHealth then
                if char_valid() then
                    text.Text = p.Name.."\n["..math.floor(h.Health).."/"..h.MaxHealth.."]"
                else
                    text.Text = p.Name
                end
            else
                text.Text = p.Name
            end
        else
            text.Visible = false
        end
    end)
end

local activatedESPPlayer;

espSection:addToggle("Player ESP", nil, function(v)
    ESPPlayerToggle = v
    if activatedESPPlayer ~= true and v then
        activatedESPPlayer = true
        local function p_added(p)
            if p.Character then
                esp(p,p.Character)
            end
            p.CharacterAdded:Connect(function(cr)
                esp(p,cr)
            end)
        end
        
        for i,p in next, ps:GetPlayers() do 
            if p ~= lp then
                p_added(p)
            end
        end
        
        ps.PlayerAdded:Connect(p_added)
    end
end)

espSection:addSlider("Max Distance", 10000, 0, 10000, function(v)
    ESPPlayerMaxDistance = v
end)

espSection:addToggle("Show health", true, function(v)
    ESPPlayerShowHealth = v
end)

espSection:addToggle("Show Distance", true, function(v)
    ESPPlayerShowDistance = v
end)

local ESPMobSection = visualPage:addSection("Mob ESP")

local MOBEspToggle;
local MobESPColor = Color3.fromRGB(226, 35, 35)
local ESPMobShowDistance = true
local ESPMobShowHealth = true
local ESPMobMaxDistance = 10000;

local function esp_mob(cr)
    local h = cr:WaitForChild("Humanoid")
    local hrp = cr:WaitForChild("HumanoidRootPart")
    local extractedString = cr.Name:match("(.+)_")
    local mobname = AllMobs[extractedString] or cr.Name

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true 
    text.Font = 2
    text.Color = MobESPColor
    text.Size = 13

    local c1
    local c2
    local c3
    local c4

    local function dc()
        text.Visible = false
        text:Remove()
        if c1 then
            c1:Disconnect()
            c1 = nil 
        end
        if c2 then
            c2:Disconnect()
            c2 = nil 
        end
        if c3 then
            c3:Disconnect()
            c3 = nil 
        end
        if c4 then
            c4:Disconnect()
            c4 = nil 
        end
    end

    c4 = game.workspace.Entities.ChildRemoved:Connect(function(b)
        if b.Name == cr.Name then
            dc()
        end
    end)

    c2 = h.Died:Connect(function()
        dc()
    end)

    c3 = h.HealthChanged:Connect(function(v)
        if (h:GetState() == Enum.HumanoidStateType.Dead) then
            dc()
        end
    end)

    c1 = rs.RenderStepped:Connect(function()
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)
        if hrp_onscreen and MOBEspToggle and char_valid() and (Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude <= ESPMobMaxDistance then
            text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
            text.Visible = true
            text.Color = MobESPColor
            if ESPMobShowDistance and ESPMobShowHealth ~= true then
                if char_valid() then
                    text.Text = mobname.."\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude)).."m"
                else
                    text.Text = mobname
                end
            elseif ESPMobShowDistance and ESPMobShowHealth then
                if char_valid() then
                    text.Text = mobname.."\n["..math.floor(h.Health).."/"..h.MaxHealth.."]\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude)).."m"
                else
                    text.Text = mobname
                end
            elseif ESPMobShowDistance ~= true and ESPMobShowHealth then
                if char_valid() then
                    text.Text = mobname.."\n["..math.floor(h.Health).."/"..h.MaxHealth.."]"
                else
                    text.Text = mobname
                end
            else
                text.Text = mobname
            end
        elseif cr == nil then
            dc()
        else
            text.Visible = false
        end
    end)
end

local activatedMobESP;

ESPMobSection:addToggle("Mob ESP", nil, function(v)
    MOBEspToggle = v
    if activatedMobESP ~= true and v then
        activatedMobESP = true
        
        for i,v in pairs(game.workspace.Entities:GetChildren()) do
            if Is_Player(v.Name) ~= true and MOBEspToggle and string.find(v.Name, "_") then
                local extractedString = v.Name:match("(.+)_")
                if extractedString ~= "FlashClone" and v:FindFirstChild("Humanoid") then
                    esp_mob(v)
                end
            end
        end
        
        game.workspace.Entities.ChildAdded:Connect(function(p)
            if p ~= nil then
                if p:IsA("Model") then
                    if Is_Player(p.Name) ~= true and MOBEspToggle and string.find(p.Name, "_") then
                        local extractedString = p.Name:match("(.+)_")
                        if extractedString ~= "FlashClone" then
                            esp_mob(p)
                        end
                    end
                end
            end
        end)
    end
end)

ESPMobSection:addSlider("Max Distance", 10000, 0, 10000, function(v)
    ESPMobMaxDistance = v
end)

ESPMobSection:addToggle("Show health", true, function(v)
    ESPMobShowHealth = v
end)

ESPMobSection:addToggle("Show Distance", true, function(v)
    ESPMobShowDistance = v
end)

local ESPMissionSection = visualPage:addSection("Mission ESP")

local activatedMissionESP;
local MissionESPToggle;
local ESPMissionDistance;
local MissionESPColorSelected = Color3.fromRGB(233, 255, 0)
local ESPMissionMaxDistance = 10000;

local function esp_mission(cr)
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true 
    text.Font = 2
    text.Color = MobESPColor
    text.Size = 13

    local c1
    local c2
    local c3

    local function dc()
        text.Visible = false
        text:Remove()
        if c1 then
            c1:Disconnect()
            c1 = nil 
        end
        if c2 then
            c2:Disconnect()
            c2 = nil 
        end
        if c3 then
            c3:Disconnect()
            c3 = nil 
        end
    end

    c2 = game:GetService("Workspace").NPCs.MissionNPC.DescendantRemoving:Connect(function(b)
        if b == cr then
            dc()
        end
    end)

    c1 = rs.RenderStepped:Connect(function()
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(cr.Position)
        if hrp_onscreen and MissionESPToggle and char_valid() and (Self.Character.HumanoidRootPart.Position - cr.Position).magnitude <= ESPMissionMaxDistance then
            text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
            text.Visible = true
            text.Color = MissionESPColorSelected
            if ESPMissionDistance then
                if char_valid() then
                    text.Text = "Mission\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - cr.Position).magnitude)).."m"
                end
            else
                text.Text = "Mission"
            end
        elseif cr == nil then
            dc()
        else
            text.Visible = false
        end
    end)
end

ESPMissionSection:addToggle("Mission ESP", nil, function(v)
    MissionESPToggle = v
    if activatedMissionESP ~= true and v then
        activatedMissionESP = true
        local function mission_added(p)
            if p:IsA("Model") and p.Name == "MissionBoard" and MissionESPToggle then
                local part = p:FindFirstChildOfClass("Part") or nil
                if part then
                    esp_mission(part)
                end
            end
        end
        
        for i,v in pairs(game:GetService("Workspace").NPCs.MissionNPC:GetChildren()) do
            if v:IsA("Model") and v.Name == "MissionBoard" and MissionESPToggle then
                local part = v:FindFirstChildOfClass("Part") or nil
                if part then
                    esp_mission(part)
                end
            end
        end
        
        game:GetService("Workspace").NPCs.MissionNPC.ChildAdded:Connect(mission_added)
    end
end)

ESPMissionSection:addSlider("Max Distance", 10000, 0, 10000, function(v)
    ESPMissionMaxDistance = v
end)

ESPMissionSection:addToggle("Show distance", nil, function(v)
    ESPMissionDistance = v
end)

local ESPNPCSection = visualPage:addSection("NPCs ESP")

local choosenNPCtoESP;
local ESPnpcToggle;
local NPCColorESP = Color3.new(126, 3, 231)
local executedNPCESP;
local ESPNPCDistance = true

local NPCsData = {
    ["Harribel"] = "PartialRes"
}

ESPNPCSection:addDropdown("NPCs", {"Harribel"}, function(v)
    choosenNPCtoESP = v
end)

local function esp_npc(cr)
    local npcname = NPCsData[choosenNPCtoESP] or cr.Name
    local hrp = cr:WaitForChild("HumanoidRootPart")
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true 
    text.Font = 2
    text.Color = NPCColorESP
    text.Size = 13

    local c1
    local c2
    local c3

    local function dc()
        text.Visible = false
        text:Remove()
        if c1 then
            c1:Disconnect()
            c1 = nil 
        end
        if c2 then
            c2:Disconnect()
            c2 = nil 
        end
        if c3 then
            c3:Disconnect()
            c3 = nil 
        end
    end

    c2 = game:GetService("Workspace").NPCs.PartialRes.ChildRemoved:Connect(function(b)
        if b == cr then
            dc()
        end
    end)

    c1 = rs.RenderStepped:Connect(function()
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)
        if hrp_onscreen and ESPnpcToggle and char_valid() and (Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude <= ESPMaxDistance then
            text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
            text.Visible = true
            text.Color = NPCColorESP
            if ESPNPCDistance then
                if char_valid() then
                    text.Text = npcname.."\n"..tostring(math.floor((Self.Character.HumanoidRootPart.Position - hrp.Position).magnitude)).."m"
                end
            else
                text.Text = npcname
            end
        elseif cr == nil then
            dc()
        else
            text.Visible = false
        end
    end)
end

ESPNPCSection:addToggle("Enabled ESP", nil, function(v)
    ESPnpcToggle = v
    if executedNPCESP ~= true then
        executedNPCESP = true

        if choosenNPCtoESP ~= nil then
            for i,v in pairs(game:GetService("Workspace").NPCs.PartialRes:GetChildren()) do
                if v:FindFirstChild(choosenNPCtoESP) then
                    esp_npc(v)
                end
            end
        end
    end
end)

ESPNPCSection:addToggle("Show distance", true, function(v)
    ESPNPCDistance = v
end)

local streamermodesec = visualPage:addSection("Streamer Mode")

local StreamerModeToggle;

streamermodesec:addToggle("Streamer Mode", nil, function(v33)
    StreamerModeToggle = v33
    if StreamerModeToggle then
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") then
            for i,v in pairs(game.Players.LocalPlayer.PlayerGui.Leaderboard.PlayerList.PlayerListFrame:GetChildren()) do
                if v.Name == Self.Name then
                    v.Visible = false
                end
            end
            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Settings.Frame:GetChildren()) do
                if v.Name == "CharacterName" or v.Name == "CurrentServer" or v.Name == "PlayerName" or v.Name == "ServerTime" or v.Name == "Region" then
                    v.Visible = false
                end
            end
        end
    else
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") then
            for i,v in pairs(game.Players.LocalPlayer.PlayerGui.Leaderboard.PlayerList.PlayerListFrame:GetChildren()) do
                if v.Name == Self.Name then
                    v.Visible = true
                end
            end
            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Settings.Frame:GetChildren()) do
                if v.Name == "CharacterName" or v.Name == "CurrentServer" or v.Name == "PlayerName" or v.Name == "ServerTime" or v.Name == "Region" then
                    v.Visible = true
                end
            end
        end
    end
end)

local espSettingsSector = visualPage:addSection("ESP Settings")

espSettingsSector:addColorPicker("Player ESP", Color3.fromRGB(3, 231, 107), function(v)
    PlayerESPColor = v
end)

espSettingsSector:addColorPicker("Mob ESP", Color3.fromRGB(226, 35, 35), function(v)
    MobESPColor = v
end)

espSettingsSector:addColorPicker("Mission ESP", Color3.fromRGB(3, 231, 107), function(v)
    MissionESPColorSelected = v
end)

espSettingsSector:addColorPicker("NPC ESP", Color3.new(126, 3, 231), function(v)
    NPCColorESP = v
end)

espSettingsSector:addToggle("Text Outline", nil, function(v)
    ESPTextOutlineSettings = v
end)

local settingsPage = venyx:addPage("Settings", 5012544693)
local teleportSpeed = settingsPage:addSection("Teleport Options")

TweenTPSpeed = 150

teleportSpeed:addSlider("Tween Speed", 150, 50, 500, function(v)
    TweenTPSpeed = v
end)


venyx:SelectPage(venyx.pages[1], true)
