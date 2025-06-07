local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MainGui = Instance.new("ScreenGui", gethui())
MainGui.DisplayOrder = 999
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.Parent = MainGui

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local UIListLayout_Tabs = Instance.new("UIListLayout")
UIListLayout_Tabs.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_Tabs.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_Tabs.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout_Tabs.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Tabs.Padding = UDim.new(0, 5)
UIListLayout_Tabs.Parent = TabBar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -10, 1, -40)
ContentContainer.Position = UDim2.new(0, 5, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local tabs = {}
local contentFrames = {}
local activeTab = nil
local activeColor = Color3.fromRGB(80, 80, 80)
local inactiveColor = Color3.fromRGB(35, 35, 35)

local function switchTab(tabName)
    if activeTab == tabName then return end

    for name, button in pairs(tabs) do
        local contentFrame = contentFrames[name]
        local isTarget = (name == tabName)

        if isTarget then
            button:TweenSize(UDim2.new(0, 100, 0, 24), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = activeColor}):Play()
            contentFrame.Visible = true
            TweenService:Create(contentFrame, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
        else
            button:TweenSize(UDim2.new(0, 100, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = inactiveColor}):Play()
            local fadeOut = TweenService:Create(contentFrame, TweenInfo.new(0.3), {GroupTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Once(function()
                if activeTab ~= name then
                    contentFrame.Visible = false
                end
            end)
        end
    end
    activeTab = tabName
end

local function createTab(name, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 100, 0, 20)
    TabButton.BackgroundColor3 = inactiveColor
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = order
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.Text = name
    TabButton.Parent = TabBar

    local UICorner_Button = Instance.new("UICorner")
    UICorner_Button.CornerRadius = UDim.new(0, 4)
    UICorner_Button.Parent = TabButton
    
    tabs[name] = TabButton

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.GroupTransparency = 1
    ContentFrame.Parent = ContentContainer
    
    contentFrames[name] = ContentFrame

    TabButton.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
    
    return ContentFrame
end

local function createCategoryBox(parent, title)
    local Box = Instance.new("Frame")
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Box.Size = UDim2.new(0, 260, 1, -10)
    Box.Parent = parent

    local UICorner_Box = Instance.new("UICorner")
    UICorner_Box.CornerRadius = UDim.new(0, 4)
    UICorner_Box.Parent = Box

    local BoxTitle = Instance.new("TextLabel")
    BoxTitle.Size = UDim2.new(1, 0, 0, 25)
    BoxTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BoxTitle.BorderSizePixel = 0
    BoxTitle.Font = Enum.Font.SourceSansBold
    BoxTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    BoxTitle.TextSize = 14
    BoxTitle.Text = title
    BoxTitle.Parent = Box
    
    local UICorner_Title = Instance.new("UICorner")
    UICorner_Title.CornerRadius = UDim.new(0, 4)
    UICorner_Title.Parent = BoxTitle

    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Size = UDim2.new(1, -10, 1, -30)
    OptionsContainer.Position = UDim2.new(0, 5, 0, 25)
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.Parent = Box

    local UIListLayout_Options = Instance.new("UIListLayout")
    UIListLayout_Options.Padding = UDim.new(0, 8)
    UIListLayout_Options.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Options.Parent = OptionsContainer

    return OptionsContainer
end

local aimbotTab = createTab("Aimbot", 1)
local espTab = createTab("ESP", 2)
local miscTab = createTab("Misc", 3)
local configTab = createTab("Config", 4)

local UIGridLayout_Content = Instance.new("UIGridLayout")
UIGridLayout_Content.CellPadding = UDim2.new(0, 10, 0, 10)
UIGridLayout_Content.CellSize = UDim2.new(0, 260, 1, -10)
UIGridLayout_Content.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout_Content.Parent = aimbotTab

local aimbotGeneralOptions = createCategoryBox(aimbotTab, "General")
local aimbotTriggerOptions = createCategoryBox(aimbotTab, "Trigger")

local function createToggle(parent, text)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 20)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextSize = 14
    Label.Text = text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.3, 0, 1, 0)
    ToggleButton.Position = UDim2.new(0.7, 0, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0.5, 0, 1, -4)
    ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    local UICorner_Toggle = Instance.new("UICorner")
    UICorner_Toggle.CornerRadius = UDim.new(0, 3)
    UICorner_Toggle.Parent = ToggleButton
    
    local UICorner_Indicator = Instance.new("UICorner")
    UICorner_Indicator.CornerRadius = UDim.new(0, 3)
    UICorner_Indicator.Parent = ToggleIndicator
    
    local toggled = false
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        local indicatorPos = toggled and UDim2.new(0.5, -2, 0, 2) or UDim2.new(0, 2, 0, 2)
        local indicatorColor = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = indicatorPos, BackgroundColor3 = indicatorColor}):Play()
    end)
end

createToggle(aimbotGeneralOptions, "Enable Aimbot")
createToggle(aimbotGeneralOptions, "Team Check")
createToggle(aimbotGeneralOptions, "Visibility Check")

createToggle(aimbotTriggerOptions, "Enable Triggerbot")

local dragging
local dragInput
local dragStart
local startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.Y < MainFrame.AbsolutePosition.Y + TabBar.AbsoluteSize.Y then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)
MainFrame.InputChanged:Connect(function(input)
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

switchTab("Aimbot")
