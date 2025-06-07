local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GuiLib = {}
GuiLib.ToggleBind = Enum.KeyCode.RightShift
GuiLib.MainFrame = nil
GuiLib.Visible = true

function GuiLib:CreateToggle(params)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 20)
    Frame.BackgroundTransparency = 1
    Frame.Parent = params.Parent
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextSize = 14
    Label.Text = params.Text or "Toggle"
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 40, 1, -4)
    Button.Position = UDim2.new(1, -40, 0, 2)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = ""
    Button.Parent = Frame
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0.5, 0, 1, -4)
    Indicator.Position = UDim2.new(0, 2, 0, 2)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Button
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 3)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 3)
    local toggled = params.Default or false
    local function updateState()
        local pos = toggled and UDim2.new(0.5, -2, 0, 2) or UDim2.new(0, 2, 0, 2)
        local color = toggled and Color3.fromRGB(98, 0, 234) or Color3.fromRGB(200, 50, 50)
        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = pos, BackgroundColor3 = color}):Play()
        if params.Callback then task.spawn(params.Callback, toggled) end
    end
    Button.MouseButton1Click:Connect(function() toggled = not toggled; updateState() end)
    updateState()
end

function GuiLib:CreateKeybind(params)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 20)
    Frame.BackgroundTransparency = 1
    Frame.Parent = params.Parent
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextSize = 14
    Label.Text = params.Text or "Keybind"
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.5, 0, 1, 0)
    Button.Position = UDim2.new(0.5, 0, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.TextSize = 12
    Button.Parent = Frame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 3)
    local currentBind = params.Default or Enum.KeyCode.None
    Button.Text = tostring(currentBind.Name)
    Button.MouseButton1Click:Connect(function()
        Button.Text = "..."
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            currentBind = input.KeyCode
            Button.Text = tostring(currentBind.Name)
            if params.Callback then task.spawn(params.Callback, currentBind) end
            connection:Disconnect()
        end)
    end)
end

local MainGui = Instance.new("ScreenGui", gethui())
MainGui.Name = "NovaFramework"
MainGui.DisplayOrder = 999
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
MainGui.IgnoreGuiInset = true

GuiLib.MainFrame = Instance.new("Frame")
local MainFrame = GuiLib.MainFrame
MainFrame.Size = UDim2.new(0, 750, 0, 400)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.ClipsDescendants = true
MainFrame.Parent = MainGui

local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(1, -200, 1, 0)
LeftPanel.BackgroundTransparency = 1
LeftPanel.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabBar.BorderSizePixel = 0
TabBar.Parent = LeftPanel
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
ContentContainer.Parent = LeftPanel

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0, 200, 1, 0)
RightPanel.Position = UDim2.new(1, -200, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
RightPanel.Parent = MainFrame

local ESPPreviewTitle = Instance.new("TextLabel")
ESPPreviewTitle.Size = UDim2.new(1, 0, 0, 30)
ESPPreviewTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPPreviewTitle.Font = Enum.Font.SourceSansBold
ESPPreviewTitle.TextColor3 = Color3.fromRGB(200,200,200)
ESPPreviewTitle.Text = "ESP Preview"
ESPPreviewTitle.TextSize = 14
ESPPreviewTitle.Parent = RightPanel

local Viewport = Instance.new("ViewportFrame")
Viewport.Size = UDim2.new(1, -10, 1, -40)
Viewport.Position = UDim2.new(0, 5, 0, 35)
Viewport.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Viewport.Ambient = Color3.new(0.5, 0.5, 0.5)
Viewport.LightColor = Color3.new(1, 1, 1)
Viewport.LightDirection = Vector3.new(-1, -1, -1)
Viewport.Parent = RightPanel
local World = Instance.new("WorldModel", Viewport)
local Cam = Instance.new("Camera", Viewport)
Viewport.CurrentCamera = Cam

task.spawn(function()
    if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
    local PreviewChar = LocalPlayer.Character:Clone()
    PreviewChar.Parent = World
    local Humanoid = PreviewChar:FindFirstChildOfClass("Humanoid")
    if Humanoid then Humanoid:UnequipTools() end
    for _, obj in ipairs(PreviewChar:GetDescendants()) do if obj:IsA("BasePart") then obj.Anchored = true end end
    RunService.RenderStepped:Connect(function(dt)
        local hrp = PreviewChar:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, dt * 1.5, 0) end
        local extents = PreviewChar:GetExtentsSize()
        Cam.CFrame = CFrame.new(Vector3.new(0, extents.Y/2, extents.Z * 2.5)) * CFrame.Angles(0, math.rad(180), 0)
    end)
end)

local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local GameTitle = Instance.new("TextLabel")
GameTitle.Size = UDim2.new(0, 200, 0, 30)
GameTitle.Position = UDim2.new(1, -200, 0, 0)
GameTitle.BackgroundTransparency = 1
GameTitle.Font = Enum.Font.SourceSansBold
GameTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
GameTitle.TextSize = 12
GameTitle.Text = GameName
GameTitle.TextXAlignment = Enum.TextXAlignment.Right
GameTitle.Parent = TabBar

local tabs = {}
local contentFrames = {}
local activeTab = nil
local activeColor = Color3.fromRGB(98, 0, 234)
local inactiveColor = Color3.fromRGB(35, 35, 35)

local function switchTab(tabName)
    if activeTab == tabName then return end
    for name, button in pairs(tabs) do
        local contentFrame = contentFrames[name]
        if not contentFrame then continue end
        local isTarget = (name == tabName)
        if isTarget then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = activeColor}):Play()
            contentFrame.Visible = true
            TweenService:Create(contentFrame, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
        else
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = inactiveColor}):Play()
            local fadeOut = TweenService:Create(contentFrame, TweenInfo.new(0.3), {GroupTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Once(function() if activeTab ~= name then contentFrame.Visible = false end end)
        end
    end
    activeTab = tabName
end

local function createTab(name, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 100, 0, 22)
    TabButton.BackgroundColor3 = inactiveColor
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = order
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.Text = name
    TabButton.Parent = TabBar
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)
    tabs[name] = TabButton
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.GroupTransparency = 1
    ContentFrame.Parent = ContentContainer
    contentFrames[name] = ContentFrame
    TabButton.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createCategoryBox(parent, title)
    local Box = Instance.new("Frame")
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Box.Parent = parent
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    local BoxTitle = Instance.new("TextLabel")
    BoxTitle.Size = UDim2.new(1, 0, 0, 25)
    BoxTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BoxTitle.Font = Enum.Font.SourceSansBold
    BoxTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    BoxTitle.TextSize = 14
    BoxTitle.Text = title
    BoxTitle.Parent = Box
    Instance.new("UICorner", BoxTitle).CornerRadius = UDim.new(0, 4)
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Size = UDim2.new(1, -10, 1, -30)
    OptionsContainer.Position = UDim2.new(0, 5, 0, 25)
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.Parent = Box
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = OptionsContainer
    return OptionsContainer
end

createTab("Aimbot", 1)
createTab("ESP", 2)
createTab("Misc", 3)
createTab("Config", 4)

local aimbotLayout = Instance.new("UIGridLayout", contentFrames["Aimbot"])
aimbotLayout.CellPadding = UDim2.new(0, 10, 0, 10)
aimbotLayout.CellSize = UDim2.new(0, 260, 1, -10)
aimbotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local aimbotGeneral = createCategoryBox(contentFrames["Aimbot"], "General")
local aimbotTrigger = createCategoryBox(contentFrames["Aimbot"], "Trigger")
GuiLib:CreateToggle({Parent = aimbotGeneral, Text = "Enable Aimbot"})
GuiLib:CreateToggle({Parent = aimbotGeneral, Text = "Team Check"})
GuiLib:CreateToggle({Parent = aimbotTrigger, Text = "Enable Triggerbot"})

local miscLayout = Instance.new("UIListLayout", contentFrames["Misc"])
miscLayout.Padding = UDim2.new(0, 10)
miscLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local miscSettings = createCategoryBox(contentFrames["Misc"], "Settings")
miscSettings.Size = UDim2.new(1, -10, 0, 60)
GuiLib:CreateKeybind({Parent = miscSettings, Text = "Toggle Bind", Default = GuiLib.ToggleBind, Callback = function(key) GuiLib.ToggleBind = key end})

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == GuiLib.ToggleBind then
        GuiLib.Visible = not GuiLib.Visible
        local scale = GuiLib.Visible and 1 or 0
        local transparency = GuiLib.Visible and 0 or 1
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(750 * scale, 400 * scale), GroupTransparency = transparency}):Play()
    end
end)

MainFrame.Size = UDim2.fromScale(0,0)
MainFrame.GroupTransparency = 1
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 750, 0, 400), GroupTransparency = 0}):Play()
switchTab("Aimbot")
