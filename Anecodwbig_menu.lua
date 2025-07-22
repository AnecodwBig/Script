local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "UltraTPMenu"

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -20)
toggleBtn.Text = "≡"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 24
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 470)
frame.Position = UDim2.new(0, 70, 0.5, -235)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Переливающийся текст сверху
local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "By AneCodwBig"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 22
titleLabel.TextStrokeTransparency = 0.7
titleLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Center

local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(139, 0, 255),
}

local colorIndex = 1
local function tweenToNextColor()
    local nextIndex = colorIndex % #colors + 1
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(titleLabel, tweenInfo, {TextColor3 = colors[nextIndex]})
    tween:Play()
    tween.Completed:Connect(function()
        colorIndex = nextIndex
        tweenToNextColor()
    end)
end
tweenToNextColor()

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 280, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = text
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.Parent = frame
	return btn
end

local function createLabel(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 280, 0, 24)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.Font = Enum.Font.SourceSansBold
	lbl.TextSize = 16
	lbl.Text = text
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = frame
	return lbl
end

local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(0, 280, 0, 30)
searchBox.PlaceholderText = "TP by username (start typing)"
searchBox.ClearTextOnFocus = false
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.Font = Enum.Font.SourceSans
searchBox.TextSize = 18
searchBox.BorderSizePixel = 0
searchBox.TextXAlignment = Enum.TextXAlignment.Left

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(0, 280, 0, 150)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.BorderSizePixel = 0

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local tpButtons = {}

local function clearTPButtons()
	for _, btn in pairs(tpButtons) do
		btn:Destroy()
	end
	tpButtons = {}
end

local function updateTPList(filter)
	clearTPButtons()
	filter = filter:lower()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local name = player.Name:lower()
			if filter == "" or name:find(filter) then
				local btn = Instance.new("TextButton", scrollFrame)
				btn.Size = UDim2.new(1, -10, 0, 30)
				btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
				btn.TextColor3 = Color3.new(1, 1, 1)
				btn.Font = Enum.Font.SourceSansBold
				btn.TextSize = 18
				btn.Text = player.Name
				btn.BorderSizePixel = 0

				btn.MouseButton1Click:Connect(function()
					local char = LocalPlayer.Character
					local targetChar = player.Character
					if char and targetChar then
						local hrp = targetChar:FindFirstChild("HumanoidRootPart")
						if hrp then
							char:MoveTo(hrp.Position + Vector3.new(0,3,0))
						end
					end
				end)

				table.insert(tpButtons, btn)
			end
		end
	end
	task.wait()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

updateTPList("")

searchBox.Changed:Connect(function(prop)
	if prop == "Text" then
		updateTPList(searchBox.Text)
	end
end)

local tpRandomBtn = createButton("TP to Random Player")
tpRandomBtn.MouseButton1Click:Connect(function()
	local playersList = {}
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(playersList, player)
		end
	end
	if #playersList > 0 then
		local randPlayer = playersList[math.random(#playersList)]
		LocalPlayer.Character:MoveTo(randPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
	end
end)

local showHP = false
local hpLabels = {}

local function toggleHP(show)
	showHP = show
	for player, gui in pairs(hpLabels) do
		if gui and gui.Parent then
			gui:Destroy()
		end
	end
	hpLabels = {}

	if showHP then
		for _, player in pairs(Players:GetPlayers()) do
			local char = player.Character
			if char then
				local head = char:FindFirstChild("Head")
				local humanoid = char:FindFirstChildOfClass("Humanoid")
				if head and humanoid then
					local gui = Instance.new("BillboardGui")
					gui.Name = "HPDisplayGui"
					gui.Adornee = head
					gui.Size = UDim2.new(0, 100, 0, 40)
					gui.StudsOffset = Vector3.new(0, 2, 0)
					gui.AlwaysOnTop = true
					gui.Parent = head

					local label = Instance.new("TextLabel", gui)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Color3.new(1, 0, 0)
					label.TextScaled = true
					label.Font = Enum.Font.SourceSansBold
					label.Text = tostring(math.floor(humanoid.Health))

					humanoid:GetPropertyChangedSignal("Health"):Connect(function()
						if label and label.Parent then
							label.Text = tostring(math.floor(humanoid.Health))
						end
					end)

					hpLabels[player] = gui
				end
			end
		end
	else
		for _, player in pairs(Players:GetPlayers()) do
			local char = player.Character
			if char then
				local head = char:FindFirstChild("Head")
				if head then
					local gui = head:FindFirstChild("HPDisplayGui")
					if gui then
						gui:Destroy()
					end
				end
			end
		end
	end
end

local hpToggleBtn = createButton("Show HP Above Players")
hpToggleBtn.MouseButton1Click:Connect(function()
	if showHP then
		toggleHP(false)
		hpToggleBtn.Text = "Show HP Above Players"
	else
		toggleHP(true)
		hpToggleBtn.Text = "Hide HP Above Players"
	end
end)

local speedLabel = createLabel("Walk Speed:")
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 280, 0, 30)
speedBox.Text = "16"
speedBox.PlaceholderText = "Enter speed (number)"
speedBox.ClearTextOnFocus = false
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 18
speedBox.BorderSizePixel = 0
speedBox.TextXAlignment = Enum.TextXAlignment.Left

local jumpLabel = createLabel("Jump Power:")
local jumpBox = Instance.new("TextBox", frame)
jumpBox.Size = UDim2.new(0, 280, 0, 30)
jumpBox.Text = "50"
jumpBox.PlaceholderText = "Enter jump power (number)"
jumpBox.ClearTextOnFocus = false
jumpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.Font = Enum.Font.SourceSans
jumpBox.TextSize = 18
jumpBox.BorderSizePixel = 0
jumpBox.TextXAlignment = Enum.TextXAlignment.Left

local function applySpeedJump()
	local char = LocalPlayer.Character
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local speed = tonumber(speedBox.Text)
	if speed and speed > 0 then
		humanoid.WalkSpeed = speed
	end

	local jump = tonumber(jumpBox.Text)
	if jump and jump > 0 then
		humanoid.JumpPower = jump
	end
end

speedBox.FocusLost:Connect(applySpeedJump)
jumpBox.FocusLost:Connect(applySpeedJump)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

scrollFrame.Parent = frame