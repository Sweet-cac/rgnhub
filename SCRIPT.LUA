local highChestOnly = true
local godsChalicSniper = false
local AllowRunService = true

repeat task.wait(4) until game:IsLoaded()

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour

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

local AllowRunServiceBind = Instance.new("BindableFunction")

function AllowRunServiceBind.OnInvoke(args)
    if args == "Enable" then
        AllowRunService = true
    elseif args == "Disable" then
        AllowRunService = false
    end
end

-- Giao diện chính
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MainGUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.4, 0, 0.3, 0)
    Frame.Position = UDim2.new(0.3, 0, 0.35, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.2, 0)
    Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Title.Text = "Gaming UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24
    Title.TextStrokeTransparency = 0
    Title.Parent = Frame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.8, 0, 0.15, 0)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleButton.Text = "Toggle Service"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.TextSize = 20
    ToggleButton.MouseButton1Click:Connect(function()
        AllowRunService = not AllowRunService
        local status = AllowRunService and "Enabled" or "Disabled"
        ToggleButton.Text = "Service " .. status
    end)
    ToggleButton.Parent = Frame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0.2, 0)
    StatusLabel.Position = UDim2.new(0, 0, 0.6, 0)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    StatusLabel.Text = "Status: Running"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 18
    StatusLabel.TextStrokeTransparency = 0
    StatusLabel.Parent = Frame

    -- Updating status based on AllowRunService
    task.spawn(function()
        while true do
            if AllowRunService then
                StatusLabel.Text = "Status: Running"
            else
                StatusLabel.Text = "Status: Paused"
            end
            task.wait(1)
        end
    end)
end

createUI()

task.spawn(function()
    while task.wait() do
        if godsChalicSniper then
            if stuff then
                AllowRunService = false
            end
        end
    end
end)

task.spawn(function()
    while true and task.wait(.5) do
        if AllowRunService then
            local ohString1 = "SetTeam"
            local ohString2 = "Marines"
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(ohString1, ohString2)
        end
    end
end)

task.spawn(function()
    while true and task.wait() do
        if AllowRunService then
            if highChestOnly == false then
                local hasChar = game.Players.LocalPlayer:FindFirstChild("Character")
                if not game.Players.LocalPlayer.Character then
                    -- Your existing code here
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
