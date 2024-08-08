-- Các thiết lập và biến gốc
local highChestOnly = true
local godsChalicSniper = false

repeat task.wait(4) until game:IsLoaded()

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false

-- Đọc danh sách server từ file
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)

if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

-- Hàm quay lại teleport
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
    for i, v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _, Existing in pairs(AllIDs) do
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

-- Hàm teleport
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

-- Xử lý thông báo lỗi bảo mật
local veryImportantWaitTime = 0.5
task.spawn(function()
    while task.wait(veryImportantWaitTime) do
        pcall(function()
            for i, v in pairs(game.CoreGui:GetDescendants()) do
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

-- Điều khiển việc bật/tắt auto farm
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
        Title = "Auto Farm Chess",
        Text = "By Sweet Hub",
        Icon = "rbxthumb://type=Asset&id=18856351865&w=150&h=150",
        Duration = math.huge,
        Callback = AllowRunServiceBind,
        Button1 = "Enable",
        Button2 = "Disable",
    })
end

-- Thông báo khởi tạo
local CoreGui = game:GetService("StarterGui")
CoreGui:SetCore("SendNotification", {
    Title = "Auto Farm Chess",
    Text = "By Sweet Hub",
    Icon = "rbxthumb://type=Asset&id=18856351865&w=150&h=150",
    Duration = math.huge,
    Callback = AllowRunServiceBind,
    Button1 = "Enable",
    Button2 = "Disable",
})

-- Tạo giao diện gaming với liên kết Discord và nút bật/tắt auto farm
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local DiscordButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local TitleLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.3

TitleLabel.Parent = Frame
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0.2, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Auto Farm Script by Vhung hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 24

DiscordButton.Parent = Frame
DiscordButton.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
DiscordButton.Size = Udim2.new(0.8, 0, 0.2, 0)
DiscordButton.Position = UDim2.new(0.1, 0, 0.4, 0)
DiscordButton.Text = "Join Our Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.TextSize = 24
DiscordButton.Font = Enum.Font.SourceSans

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 204, 102)
ToggleButton.Size = Udim2.new(0.8, 0, 0.2, 0)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.Text = "Toggle Auto Farm"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.SourceSans

-- Cập nhật liên kết Discord
local discordLink = "https://discord.gg/stae"  -- Thay thế bằng liên kết thực tế của bạn

DiscordButton.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    print("Discord link copied to clipboard.")
end)

-- Chức năng bật/tắt auto farm
ToggleButton.MouseButton1Click:Connect(function()
    AllowRunService = not AllowRunService
    if AllowRunService then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 204, 102)
        ToggleButton.Text = "Auto Farm Enabled"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(204, 0, 0)
        ToggleButton.Text = "Auto Farm Disabled"
    end
end)

-- Auto farm chess
task.spawn(function()
    while true and task.wait(0.5) do
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
                    -- Do nothing
                else
                    local hasCrewTag = game.Players.LocalPlayer.Character:FindFirstChild("CrewBBG", true)
                    if hasCrewTag then hasCrewTag:Destroy() end
                    local hasHumanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
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
                    -- Do nothing
                else
                    local hasCrewTag = game.Players.LocalPlayer.Character:FindFirstChild("CrewBBG", true)
                    if hasCrewTag then hasCrewTag:Destroy() end
                    local hasHumanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
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
