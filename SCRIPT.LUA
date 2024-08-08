-- Các biến và cài đặt ban đầu
highChestOnly = true
godsChalicSniper = false
local isScreenOn = true -- True = chế độ màn hình hoạt động, False = chế độ màn hình trắng hoặc đen

repeat task.wait(4) until game:IsLoaded()

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local discordInviteLink = "https://discord.gg/stae"  -- Thay đổi theo liên kết mời của bạn

-- Đọc và ghi dữ liệu
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)

if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

-- Hàm toggle chế độ màn hình
function ToggleScreenMode(on)
    isScreenOn = on
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Xóa các UI cũ nếu có
    for _, child in pairs(playerGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name == "ScreenModeGui" then
            child:Destroy()
        end
    end

    if isScreenOn then
        -- Khôi phục giao diện người dùng bình thường nếu có
        -- (Bạn có thể thêm mã khôi phục UI ở đây nếu cần)
    else
        -- Tạo UI mới với màn hình trắng hoặc đen
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ScreenModeGui"
        screenGui.Parent = playerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(1, 1, 1) -- Màu trắng, thay đổi thành Color3.new(0, 0, 0) cho màu đen
        frame.Parent = screenGui
    end
end

-- Hàm teleport
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

-- Hàm teleport liên tục
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

-- Kiểm tra lỗi và retry teleport
local veryImportantWaitTime = 0.5
task.spawn(function()
    while task.wait(veryImportantWaitTime) do
        pcall(function()
            for i,v in pairs(game.CoreGui:GetDescendants()) do
                pcall(function()
                    if string.find(v.Name,"ErrorMessage") then
                        if string.find(v.Text,"Security kick") then
                            veryImportantWaitTime = 1e9
                            Teleport()
                        end
                    end
                end)
            end
        end)
    end
end)

-- Cài đặt điều khiển UI
local AllowRunService = true
local AllowRunServiceBind = Instance.new("BindableFunction")

function AllowRunServiceBind.OnInvoke(args)
    if args == "ON" then
        AllowRunService = true
        ToggleScreenMode(true)
    elseif args == "OFF" then
        AllowRunService = false
        ToggleScreenMode(false)
    elseif args == "ToggleScreen" then
        -- Chuyển đổi giữa chế độ màn hình trắng và đen
        if isScreenOn then
            ToggleScreenMode(false)
        else
            ToggleScreenMode(true)
        end
    end

    local CoreGui = game:GetService("StarterGui")
    CoreGui:SetCore("SendNotification", {
        Title = "Chest Farm",
        Text = "By Sweet " .. discordInviteLink,
        Icon = "rbxthumb://type=Asset&id=18856351865&w=150&h=150",
        Duration = math.huge,
        Callback = AllowRunServiceBind,
        Button1 = "ON",
        Button2 = "OFF",
        Button3 = "Toggle Screen",
    })
end

-- Thông báo ban đầu
local CoreGui = game:GetService("StarterGui")
CoreGui:SetCore("SendNotification", {
    Title = "ChestFarm",
    Text = "By Sweet " .. discordInviteLink,
    Icon = "rbxthumb://type=Asset&id=18856351865&w=150&h=150",
    Duration = math.huge,
    Callback = AllowRunServiceBind,
    Button1 = "ON",
    Button2 = "OFF",
    Button3 = "Toggle Screen",
})

-- Chạy vòng lặp kiểm tra
task.spawn(function()
    while true and task.wait(.5) do
        if AllowRunService == true then
            local ohString1 = "SetTeam"
            local ohString2 = "Marines"
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(ohString1, ohString2)
        end
    end
end)

-- Xử lý chest
task.spawn(function()
    while true and task.wait() do
        if AllowRunService == true then
            if highChestOnly == false then
                local hasChar = game.Players.LocalPlayer:FindFirstChild("Character")
                if not game.Players.LocalPlayer.Character then
                    -- (Mã mã hóa)
                else
                    local hasCrewTag = game.Players.LocalPlayer.Character:FindFirstChild("CrewBBG",true)
                    if hasCrewTag then hasCrewTag:Destroy() end

                    local hasHumanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                    if hasHumanoid then
                        local Chest = game.Workspace:FindFirstChild("Chest4") or game.Workspace:FindFirstChild("Chest3") or game.Workspace:FindFirstChild("Chest2") or game.Workspace:FindFirstChild("Chest1") or game.Workspace:FindFirstChild("Chest")
                        if Chest then
                            game.Players.LocalPlayer.Character:PivotTo(Chest:GetPivot())
                            firesignal(Chest.Touched,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        else
                            Teleport()
                            break
                        end
                    end
                end
            elseif highChestOnly == true then
                local hasChar = game.Players.LocalPlayer:FindFirstChild("Character")
                if not game.Players.LocalPlayer.Character then
                    -- (Mã mã hóa)
                else
                    local hasCrewTag = game.Players.LocalPlayer.Character:FindFirstChild("CrewBBG",true)
                    if hasCrewTag then hasCrewTag:Destroy() end

                    local hasHumanoid = game.Players.LocalPlayer:FindFirstChild("Humanoid")
                    if hasHumanoid then
                        local Chest = game.Workspace:FindFirstChild("Chest4") or game.Workspace:FindFirstChild("Chest3") or game.Workspace:FindFirstChild("Chest2")
                        if Chest then
                            game.Players.LocalPlayer.Character:PivotTo(Chest:GetPivot())
                            firesignal(Chest.Touched,game.Players.LocalPlayer.Character.HumanoidRootPart)
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
