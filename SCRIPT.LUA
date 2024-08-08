-- Khởi tạo các dịch vụ cần thiết
local Players = game:GetService("Players")
local CoreGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

-- Khởi tạo UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamingUI"
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Header
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0.1, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
headerFrame.Parent = screenGui

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0.1, 0, 1, 0)
logo.Position = UDim2.new(0, 0, 0, 0)
logo.Image = "rbxassetid://12345678" -- Thay đổi ID thành ID logo của bạn
logo.Parent = headerFrame

local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0.1, 0, 1, 0)
menuButton.Position = UDim2.new(0.9, 0, 0, 0)
menuButton.Text = "Menu"
menuButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
menuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
menuButton.Parent = headerFrame

-- Thông Báo
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0.3, 0, 0.2, 0)
notificationFrame.Position = UDim2.new(0.35, 0, 0.05, 0)
notificationFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notificationFrame.BackgroundTransparency = 0.5
notificationFrame.Parent = screenGui

local notificationText = Instance.new("TextLabel")
notificationText.Size = UDim2.new(1, 0, 0.7, 0)
notificationText.Text = "Thông báo quan trọng"
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.TextScaled = true
notificationText.BackgroundTransparency = 1
notificationText.Parent = notificationFrame

local enableButton = Instance.new("TextButton")
enableButton.Size = UDim2.new(0.5, 0, 0.3, 0)
enableButton.Position = UDim2.new(0, 0, 0.7, 0)
enableButton.Text = "Enable"
enableButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
enableButton.TextColor3 = Color3.fromRGB(0, 0, 0)
enableButton.Parent = notificationFrame

local disableButton = Instance.new("TextButton")
disableButton.Size = UDim2.new(0.5, 0, 0.3, 0)
disableButton.Position = UDim2.new(0.5, 0, 0.7, 0)
disableButton.Text = "Disable"
disableButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
disableButton.TextColor3 = Color3.fromRGB(0, 0, 0)
disableButton.Parent = notificationFrame

-- Chức Năng Chính
local function createFunctionalityFrame(name, positionY)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0.2, 0)
    frame.Position = UDim2.new(0, 0, positionY, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.3, 0)
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.BackgroundTransparency = 1
    title.Parent = frame

    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 0.7, 0)
    statusText.Position = UDim2.new(0, 0, 0.3, 0)
    statusText.Text = "Đang hoạt động..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextScaled = true
    statusText.BackgroundTransparency = 1
    statusText.Parent = frame

    return frame
end

-- Tạo các frame cho chức năng chính
local tpFunctionality = createFunctionalityFrame("Teleportation", 0.3)
local chestFunctionality = createFunctionalityFrame("Chest Farming", 0.55)

-- Cập nhật trạng thái của các chức năng
local function updateFunctionalityStatus(frame, status)
    local statusText = frame:FindFirstChildOfClass("TextLabel", true)
    if statusText then
        statusText.Text = status
    end
end

-- Cập nhật trạng thái cho các chức năng (Ví dụ)
updateFunctionalityStatus(tpFunctionality, "Đang tìm kiếm server...")
updateFunctionalityStatus(chestFunctionality, "Đang thu thập chest...")

-- Các biến và chức năng chính của script
local highChestOnly = true
local godsChalicSniper = false
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false

repeat task.wait(4) until game:IsLoaded()

-- Đọc và ghi tệp JSON
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)

if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

function TPReturner()
    local Site
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end

    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end

    local num = 0
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)

        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end

            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

local veryImportantWaitTime = 0.5
task.spawn(function()
    while task.wait(veryImportantWaitTime) do
        pcall(function()
            for i,v in pairs(game.CoreGui:GetDescendants()) do
                pcall(function()
                    if string.find(v.Name, "ErrorMessage") then
                        if string.find(v.Text, "Security kick") then
                            veryImportantWaitTime = 1e9
                            Teleport()
                        end
                    end
                end)
            end
        end)
    end
end)

local AllowRunService = true
local AllowRunServiceBind = Instance.new("BindableFunction")

function AllowRunServiceBind.OnInvoke(args)
    if args == "Enable" then
        AllowRunService = true
    elseif args == "Disable" then
        AllowRunService = false
    end

    local CoreGui = game:GetService("StarterGui")
    CoreGui:SetCore("SendNotification", {
        Title = "kaymobile",
        Text = "By Kay hub\nJoin our Discord: [Your Discord Link Here]",
        Icon = "rbxthumb://type=Asset&id=18826502436&w=150&h=150",
        Duration = math.huge,
        Callback = AllowRunServiceBind,
        Button1 = "Enable",
        Button2 = "Disable",
    })
end

task.spawn(function()
    while task.wait() do
        task.spawn(function()
            if godsChalicSniper == true then
                if stuff then
                    AllowRunService = false
                end
            end
        end)
    end
end)

local CoreGui = game:GetService("StarterGui")
CoreGui:SetCore("SendNotification", {
    Title = "ChestFarm",
    Text = "By Vhung hub\nJoin our Discord: [Your Discord Link Here]",
    Icon = "rbxthumb://type=Asset&id=18826502436&w=150&h=150",
    Duration = math.huge,
    Callback = AllowRunServiceBind,
    Button1 = "Enable",
    Button2 = "Disable",
})

task.spawn(function()
    while true and task.wait(.5) do
        if AllowRunService == true then
            local ohString1 = "SetTeam"
            local ohString2 = "Marines"
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(ohString1, ohString2)
        end
    end
end)

task.spawn(function()
    while true and task.wait() do
        if AllowRunService == true then
            if highChestOnly == false then
                local hasChar = game.Players.LocalPlayer:FindFirstChild("Character")
                if not game.Players.LocalPlayer.Character then
                    -- Your existing code here
                else
                    local hasCrewTag = game.Players.LocalPlayer.Character:FindFirstChild("CrewBBG", true)
                    if hasCrewTag then hasCrewTag:Destroy() end
                    local hasHumanoid = game.Players.LocalPlayer:FindFirstChild("Humanoid")
                    if hasHumanoid then
                        local Chest = game.Workspace:FindFirstChild("Chest4") or game.Workspace:FindFirstChild("Chest3") or game.Workspace:FindFirstChild("Chest2") or game.Workspace:FindFirstChild("Chest1") or game.Workspace:FindFirstChild("Chest")
                        if Chest then
                            game.Players.LocalPlayer.Character:PivotTo(Chest:GetPivot())
                            firesignal(Chest.Touched, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        else
                            Teleport()
                            break
                        end
                    end
                end
            elseif highChestOnly == true then
                local hasChar = game.Players.LocalPlayer:FindFirstChild("Character")
                if not game.Players.LocalPlayer.Character then
                    -- Your existing code here
                else
                    local hasCrewTag = game.Players.LocalPlayer.Character:FindFirstChild("CrewBBG", true)
                    if hasCrewTag then hasCrewTag:Destroy() end
                    local hasHumanoid = game.Players.LocalPlayer:FindFirstChild("Humanoid")
                    if hasHumanoid then
                        local Chest = game.Workspace:FindFirstChild("Chest4") or game.Workspace:FindFirstChild("Chest3") or game.Workspace:FindFirstChild("Chest2")
                        if Chest then
                            game.Players.LocalPlayer.Character:PivotTo(Chest:GetPivot())
                            firesignal(Chest.Touched, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        else
                            Teleport()
                            break
                        end
                    end
                end
            end
        end
    end
end)
