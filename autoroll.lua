-- URL của mã Lua từ GitHub
local url = "https://raw.githubusercontent.com/"

-- Tạo giao diện người dùng
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRollGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tạo Nút Tải Mã
local loadButton = Instance.new("TextButton")
loadButton.Name = "LoadButton"
loadButton.Size = UDim2.new(0, 200, 0, 50)
loadButton.Position = UDim2.new(0.5, -100, 0.5, -25)
loadButton.Text = "Tải Mã"
loadButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loadButton.Parent = screenGui

-- Tạo Nhãn Hiển Thị Thông Tin
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(0, 300, 0, 50)
infoLabel.Position = UDim2.new(0.5, -150, 0.5, 60)
infoLabel.Text = "Thông tin sẽ xuất hiện ở đây"
infoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
infoLabel.Parent = screenGui

-- Tải mã khi nhấn nút
local function onLoadButtonClick()
    infoLabel.Text = "Đang tải mã từ URL..."
    
    local success, result = pcall(function()
        local loadedFunction = loadstring(game:HttpGet(url))
        if loadedFunction then
            loadedFunction() -- Thực thi mã đã tải
            return "Mã đã được tải và thực thi thành công!"
        else
            return "Không thể tải mã từ URL."
        end
    end)
    
    if not success then
        infoLabel.Text = "Lỗi: " .. tostring(result)
    else
        infoLabel.Text = result
    end
end

loadButton.MouseButton1Click:Connect(onLoadButtonClick)
