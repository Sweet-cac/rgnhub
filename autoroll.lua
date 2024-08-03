-- Script Lua tự động quay vòng với giao diện người dùng cho game "SOLS RNG"

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRollGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tạo Nút Quay Vòng
local rollButton = Instance.new("TextButton")
rollButton.Name = "RollButton"
rollButton.Size = UDim2.new(0, 200, 0, 50)
rollButton.Position = UDim2.new(0.5, -100, 0.5, -25)
rollButton.Text = "Quay Vòng"
rollButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
rollButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rollButton.Parent = screenGui

-- Tạo Nhãn Hiển Thị Thông Tin
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(0, 300, 0, 50)
infoLabel.Position = UDim2.new(0.5, -150, 0.5, 60)
infoLabel.Text = "Thông tin sẽ xuất hiện ở đây"
infoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
infoLabel.Parent = screenGui

-- Thực hiện hành động quay vòng khi nhấn nút
local function onRollButtonClick()
    infoLabel.Text = "Đang quay vòng..."
    wait(1) -- Thay đổi khoảng thời gian nếu cần
    infoLabel.Text = "Quay vòng xong!"
end

rollButton.MouseButton1Click:Connect(onRollButtonClick)

-- Thực hiện quay vòng tự động
local spinInterval = 10

local function autoRoll()
    while true do
        if rollButton then
            onRollButtonClick()
        end
        wait(spinInterval)
    end
end

autoRoll()
