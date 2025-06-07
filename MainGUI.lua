--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--// GUI Container
-- Use gethui() to get a clone of CoreGui for drawing on top. 
local MainGui = Instance.new("ScreenGui", gethui())
MainGui.DisplayOrder = 999
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

--// Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

--// Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local UICorner_Header = Instance.new("UICorner")
UICorner_Header.CornerRadius = UDim.new(0, 8)
UICorner_Header.Parent = Header

local Header_Title = Instance.new("TextLabel")
Header_Title.Size = UDim2.new(1, -10, 1, 0)
Header_Title.Position = UDim2.new(0, 5, 0, 0)
Header_Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Header_Title.BackgroundTransparency = 1
Header_Title.Font = Enum.Font.SourceSansBold
Header_Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Header_Title.TextSize = 18
Header_Title.Text = "Realistic Hood Gun Testing | Zenith Edition"
Header_Title.TextXAlignment = Enum.TextXAlignment.Left
Header_Title.Parent = Header

--// Draggable Logic
local dragging
local dragInput
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--// Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 120, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local UIListLayout_Tabs = Instance.new("UIListLayout")
UIListLayout_Tabs.Padding = UDim.new(0, 5)
UIListLayout_Tabs.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Tabs.Parent = TabContainer

--// Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -120, 1, -40)
ContentContainer.Position = UDim2.new(0, 120, 0, 40)
ContentContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

--// Tab Creation and Logic
local tabs = {}
local contentFrames = {}
local activeTab = nil

local function switchTab(tabName)
    for name, button in pairs(tabs) do
        local contentFrame = contentFrames[name]
        local isTarget = (name == tabName)

        -- Animate Button
        local targetColor = isTarget and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(45, 45, 45)
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

        -- Show/Hide Content
        if isTarget then
            contentFrame.Visible = true
        else
            contentFrame.Visible = false
        end
    end
    activeTab = tabName
end

local function createTab(name, order)
    -- Create Button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, 30)
    TabButton.Position = UDim2.new(0, 5, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = order
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 16
    TabButton.Text = name
    TabButton.Parent = TabContainer

    local UICorner_Button = Instance.new("UICorner")
    UICorner_Button.CornerRadius = UDim.new(0, 4)
    UICorner_Button.Parent = TabButton
    
    tabs[name] = TabButton

    -- Create Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -10, 1, -10)
    ContentFrame.Position = UDim2.new(0, 5, 0, 5)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.Parent = ContentContainer
    
    contentFrames[name] = ContentFrame

    -- Placeholder Label
    local PlaceholderLabel = Instance.new("TextLabel")
    PlaceholderLabel.Size = UDim2.new(1, 0, 1, 0)
    PlaceholderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PlaceholderLabel.BackgroundTransparency = 1
    PlaceholderLabel.Font = Enum.Font.SourceSansItalic
    PlaceholderLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    PlaceholderLabel.TextSize = 20
    PlaceholderLabel.Text = name .. " features will be developed here."
    PlaceholderLabel.Parent = ContentFrame

    -- Click Event
    TabButton.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- Create all the required tabs
createTab("Aimbot", 1)
createTab("ESP", 2)
createTab("Misc", 3)
createTab("Config", 4)

-- Set the default starting tab
switchTab("Aimbot")
