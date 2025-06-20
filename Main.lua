local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")
local Character       = Player.Character or Player.CharacterAdded:Wait()
local Humanoid        = Character:WaitForChild("Humanoid")
local HRP             = Character:WaitForChild("HumanoidRootPart")
local Mouse           = Player:GetMouse()
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
--settings
local infjump = false
local invisRunning = false
local noclipOn = false
local noclipConn
local hoverHeight
local bindFrame, bindConn, waitingBindFunction
local customBinds = {}
local infJumpEnabled = false
local infJumpConnection = nil
local espOn = false
espOn = not espOn
local spinOn = false
local spinBAV, lockBP
local savedCFrame
local invisRunning = false
local InvisibleCharacter = nil
local OriginalCharacter = nil
local voidConn = nil

-- Flight variables
local flyingEnabled = false
local flyBG, flyBV, flyConn
local ray = workspace.CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)
local hit, pos = workspace:FindPartOnRay(ray, Character)
local FunctionManager = {
	CategorizedFunctions = {},
	Categories = {},
	CurrentCategoryIndex = 1,
	OnFunctionAdded = Instance.new("BindableEvent"),
}

FunctionManager.CategorizedFunctions["All"] = {}
table.insert(FunctionManager.Categories, 1, "All")

function FunctionManager:register(name, callback, category)
	assert(type(name) == "string", "Name must be a string")
	assert(type(callback) == "function", "Callback must be a function")
	category = category or "General"
	if not self.CategorizedFunctions[category] then
		self.CategorizedFunctions[category] = {}
		table.insert(self.Categories, category)
	end
	self.CategorizedFunctions[category][name] = callback
	self.CategorizedFunctions["All"][name] = callback
	self.OnFunctionAdded:Fire(category, name, callback)
	self.OnFunctionAdded:Fire("All", name, callback)
end


function FunctionManager:getCategoryNames()
	return self.Categories
end

function FunctionManager:getFunctionsInCategory(category)
	return self.CategorizedFunctions[category] or {}
end

function FunctionManager:getCurrentCategory()
	return self.Categories[self.CurrentCategoryIndex] or "General"
end

function FunctionManager:cycleCategory()
	self.CurrentCategoryIndex = self.CurrentCategoryIndex % #self.Categories + 1
	return self:getCurrentCategory()
end




local GUI_WIDTH     = 400
local GUI_HEIGHT    = 320
local TITLE_HEIGHT  = 30
local NAV_HEIGHT    = 30
local FOOTER_HEIGHT = 30
local GRID_PADDING  = 4
local GRID_COLUMNS  = 4

local oldGui = PlayerGui:FindFirstChild("FunctionGui")
if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "C00lGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -GUI_WIDTH/2, 0.5, -GUI_HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 5, 5)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, TITLE_HEIGHT)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 4, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "C00LCLAN V1"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.new(0, 30, 0, TITLE_HEIGHT)
minBtn.Position = UDim2.new(1, -30, 0, 0)
minBtn.Text = "_"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 10, 10)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

local catNav = Instance.new("Frame")
catNav.Name = "CategoryNav"
catNav.Size = UDim2.new(1, 0, 0, NAV_HEIGHT)
catNav.Position = UDim2.new(0, 0, 0, TITLE_HEIGHT)
catNav.BackgroundTransparency = 1
catNav.Parent = mainFrame

local leftCat = Instance.new("TextButton")
leftCat.Name = "LeftCat"
leftCat.Size = UDim2.new(0, 50, 1, 0)
leftCat.Position = UDim2.new(0, 0, 0, 0)
leftCat.Text = "<"
leftCat.Font = Enum.Font.SourceSansBold
leftCat.TextSize = 24
leftCat.TextColor3 = Color3.new(1, 1, 1)
leftCat.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
leftCat.BorderSizePixel = 0
leftCat.Parent = catNav

local catLabel = Instance.new("TextLabel")
catLabel.Name = "CatLabel"
catLabel.Size = UDim2.new(1, -100, 1, 0)
catLabel.Position = UDim2.new(0, 50, 0, 0)
catLabel.BackgroundTransparency = 1
catLabel.Text = "General"
catLabel.Font = Enum.Font.SourceSansBold
catLabel.TextSize = 18
catLabel.TextColor3 = Color3.new(1, 1, 1)
catLabel.Parent = catNav

local rightCat = leftCat:Clone()
rightCat.Name = "RightCat"
rightCat.Position = UDim2.new(1, -50, 0, 0)
rightCat.Text = ">"
rightCat.Parent = catNav

local gridFrame = Instance.new("ScrollingFrame")
gridFrame.ClipsDescendants = true
gridFrame.Name               = "Grid"
gridFrame.Size               = UDim2.new(1,-2*GRID_PADDING, 0, GUI_HEIGHT - TITLE_HEIGHT - NAV_HEIGHT - FOOTER_HEIGHT - 2*GRID_PADDING)
gridFrame.Position           = UDim2.new(0, GRID_PADDING, 0, TITLE_HEIGHT + NAV_HEIGHT + GRID_PADDING)
gridFrame.BackgroundTransparency = 1
gridFrame.Parent             = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, (GUI_WIDTH - 2 * GRID_PADDING - (GRID_COLUMNS - 1) * GRID_PADDING) / GRID_COLUMNS, 0, 40)
gridLayout.CellPadding = UDim2.new(0, GRID_PADDING, 0, GRID_PADDING)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = gridFrame

local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, FOOTER_HEIGHT)
footer.Position = UDim2.new(0, 0, 1, -FOOTER_HEIGHT)
footer.BackgroundTransparency = 1
footer.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(1, 0, 1, 0)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = footer

local function updateGrid()
	for _, child in ipairs(gridFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local cat = FunctionManager:getCurrentCategory()
	catLabel.Text = cat

	for name, callback in pairs(FunctionManager:getFunctionsInCategory(cat)) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 40)
		btn.BackgroundColor3 = Color3.fromRGB(70, 10, 10)
		btn.BorderSizePixel = 0
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 16
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Text = name
		btn.TextWrapped = true
		btn.Parent = gridFrame

		btn.MouseButton1Click:Connect(function()
			pcall(callback)
		end)
	end
end

leftCat.MouseButton1Click:Connect(function()
	FunctionManager.CurrentCategoryIndex = (FunctionManager.CurrentCategoryIndex - 2) % #FunctionManager.Categories + 1
	updateGrid()
end)

rightCat.MouseButton1Click:Connect(function()
	FunctionManager:cycleCategory()
	updateGrid()
end)

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	gridFrame.Visible = not minimized
	catNav.Visible = not minimized
	footer.Visible = not minimized
	minBtn.Text = minimized and "◻" or "_"
	if minimized == true then
		mainFrame.BackgroundTransparency = 1
	else
		mainFrame.BackgroundTransparency = 0
	end
	
end)

FunctionManager:register("Bind Key", function()
	if bindFrame then return end 

	local gui = Player:FindFirstChild("PlayerGui"):FindFirstChild("C00lGUI")
	if not gui then warn("Gui not found!"); return end
	screenGui = gui

	bindFrame = Instance.new("Frame")
	bindFrame.Name = "BindKeyModal"
	bindFrame.Size = UDim2.new(1,0,1,0)
	bindFrame.BackgroundColor3 = Color3.new(0,0,0)
	bindFrame.BackgroundTransparency = 0.5
	bindFrame.ZIndex = 50
	bindFrame.Parent = screenGui

	local panel = Instance.new("Frame")
	panel.Name = "BindPanel"
	panel.Size = UDim2.new(0, 300, 0, 400)
	panel.Position = UDim2.new(0.5, -150, 0.5, -200)
	panel.BackgroundColor3 = Color3.fromRGB(35,35,35)
	panel.BorderSizePixel = 0
	panel.ZIndex = 51
	panel.Parent = bindFrame

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 60, 0, 24)
	closeBtn.Position = UDim2.new(1, -64, 0, 4)
	closeBtn.Text = "Close"
	closeBtn.Font = Enum.Font.SourceSansBold
	closeBtn.TextSize = 14
	closeBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
	closeBtn.TextColor3 = Color3.new(1,1,1)
	closeBtn.ZIndex = 52
	closeBtn.Parent = panel
	closeBtn.MouseButton1Click:Connect(function()
		bindFrame:Destroy()
		bindFrame = nil
		if bindConn then bindConn:Disconnect(); bindConn = nil end
	end)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -8, 0, 24)
	title.Position = UDim2.new(0, 4, 0, 4)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 18
	title.TextColor3 = Color3.new(1,1,1)
	title.Text = "Bind Key to Function"
	title.ZIndex = 52
	title.Parent = panel

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(1, -8, 1, -40)
	list.Position = UDim2.new(0, 4, 0, 32)
	list.CanvasSize = UDim2.new(0,0,0,0)
	list.ScrollBarThickness = 6
	list.ZIndex = 51
	list.Parent = panel

	local uiList = Instance.new("UIListLayout")
	uiList.Padding = UDim.new(0,4)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Parent = list

	local function refreshList()
		for _, child in ipairs(list:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end

		for _, cat in ipairs(FunctionManager.Categories) do
			local hdr = Instance.new("TextLabel")
			hdr.Size = UDim2.new(1,0,0,24)
			hdr.BackgroundTransparency = 1
			hdr.Font = Enum.Font.SourceSansBold
			hdr.TextSize = 16
			hdr.TextColor3 = Color3.new(1,1,0)
			hdr.Text = "["..cat.."]"
			hdr.ZIndex = 51
			hdr.Parent = list

			for name, cb in pairs(FunctionManager:getFunctionsInCategory(cat)) do
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1,0,0,24)
				btn.Font = Enum.Font.SourceSans
				btn.TextSize = 14
				btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
				btn.TextColor3 = Color3.new(1,1,1)
				btn.ZIndex = 51

				local bound = {}
				for key, fn in pairs(customBinds) do
					if fn == cb then table.insert(bound, tostring(key)) end
				end
				local suffix = #bound>0 and " ("..table.concat(bound, ",")..")" or ""
				btn.Text = name..suffix
				btn.Parent = list

				btn.MouseButton1Click:Connect(function()
					waitingBindFunction = { cb = cb, btn = btn, name = name }
					btn.Text = name.." → [Press a key]"
				end)
			end
		end

		list.CanvasSize = UDim2.new(0,0,0, uiList.AbsoluteContentSize.Y + 8)
	end
	bindConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or not waitingBindFunction then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			customBinds[input.KeyCode] = waitingBindFunction.cb
			waitingBindFunction.btn.Text = waitingBindFunction.name.." ("..tostring(input.KeyCode)..")"
			waitingBindFunction = nil
		end
	end)
	refreshList()

end, "Utility")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local fn = customBinds[input.KeyCode]
		if fn and type(fn) == "function" then
			pcall(fn)
		end
	end
end)
FunctionManager:register("JumpUp", function()
	local char = Player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.Velocity = Vector3.new(0, 100, 0) end
end, "Movement")


FunctionManager:register("Sit", function()
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.Sit = true end
end, "Movement")


FunctionManager:register("INF JUMP", function()
	infJumpEnabled = not infJumpEnabled

	if infJumpEnabled then
		local debounce = false

		infJumpConnection = UserInputService.JumpRequest:Connect(function()
			if debounce then return end
			debounce = true

			local character = Player.Character
			local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end

			task.wait()
			debounce = false
		end)
	else
		if infJumpConnection then
			infJumpConnection:Disconnect()
			infJumpConnection = nil
		end
	end
end, "Movement")

FunctionManager:register("WalkSpeed Slider", function()
	if screenGui:FindFirstChild("WalkSpeedModal") then return end

	
	local overlay = Instance.new("Frame")
	overlay.Name               = "WalkSpeedModal"
	overlay.Size               = UDim2.new(1,0,1,0)
	overlay.Position           = UDim2.new(0,0,0,0)
	overlay.BackgroundColor3   = Color3.new(0,0,0)
	overlay.BackgroundTransparency = 0.5
	overlay.ZIndex             = 50
	overlay.Parent             = screenGui

	local panel = Instance.new("Frame")
	panel.Name                  = "SliderPanel"
	panel.Size                  = UDim2.new(0, 300, 0, 100)
	panel.Position              = UDim2.new(0.5, -150, 0.5, -50)
	panel.BackgroundColor3      = Color3.fromRGB(40,40,40)
	panel.BorderSizePixel       = 0
	panel.ZIndex                = 51
	panel.Parent                = overlay

	local closeBtn = Instance.new("TextButton")
	closeBtn.Name               = "Close"
	closeBtn.Size               = UDim2.new(0,60,0,24)
	closeBtn.Position           = UDim2.new(1,-64,0,4)
	closeBtn.Font               = Enum.Font.SourceSansBold
	closeBtn.TextSize           = 14
	closeBtn.Text               = "Close"
	closeBtn.BackgroundColor3   = Color3.fromRGB(150,50,50)
	closeBtn.TextColor3         = Color3.new(1,1,1)
	closeBtn.ZIndex             = 52
	closeBtn.Parent             = panel
	closeBtn.MouseButton1Click:Connect(function()
		overlay:Destroy()
	end)

	local label = Instance.new("TextLabel")
	label.Name                  = "ValueLabel"
	label.Size                  = UDim2.new(1,-8,0,24)
	label.Position              = UDim2.new(0,4,0,4)
	label.BackgroundTransparency= 1
	label.Font                  = Enum.Font.SourceSansBold
	label.TextSize              = 18
	label.TextColor3            = Color3.new(1,1,1)
	label.Text                  = "WalkSpeed: " .. tostring(Humanoid.WalkSpeed)
	label.ZIndex                = 52
	label.Parent                = panel

	local track = Instance.new("Frame")
	track.Name                  = "Track"
	track.Size                  = UDim2.new(1,-16,0,20)
	track.Position              = UDim2.new(0,8,0,40)
	track.BackgroundColor3      = Color3.fromRGB(60,60,60)
	track.BorderSizePixel       = 0
	track.ZIndex                = 51
	track.Parent                = panel

	local fill = Instance.new("Frame")
	fill.Name                   = "Fill"
	fill.Size                   = UDim2.new(
		math.clamp((Humanoid.WalkSpeed - 8)/(100-8),0,1), 0,
		1, 0
	)
	fill.BackgroundColor3       = Color3.fromRGB(100,200,100)
	fill.BorderSizePixel        = 0
	fill.ZIndex                 = 52
	fill.Parent                 = track

	local dragging = false
	local minS, maxS = 8, 100

	local function update(x)
		local rel = math.clamp((x - track.AbsolutePosition.X)/track.AbsoluteSize.X, 0,1)
		local v = math.floor(minS + (maxS-minS)*rel)
		Humanoid.WalkSpeed = v
		label.Text = "WalkSpeed: "..v
		fill.Size = UDim2.new(rel,0,1,0)
	end

	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			update(i.Position.X)
		end
	end)
	track.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
			update(i.Position.X)
		end
	end)
end, "Movement")


FunctionManager:register("TP Behind Closest", function()

	if not  HRP then
		warn("No HumanoidRootPart found.")
		return
	end

	local closestPlayer
	local shortestDistance = math.huge


	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= Player and otherPlayer.Character then
			local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			if otherRoot then
				local distance = (otherRoot.Position - HRP.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = otherPlayer
				end
			end
		end
	end

	if closestPlayer and closestPlayer.Character then
		local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local behindPosition = targetRoot.CFrame.Position - targetRoot.CFrame.LookVector * 3
			local newCFrame = CFrame.new(behindPosition, targetRoot.Position) 
			HRP.CFrame = newCFrame

			warn("Teleported behind", closestPlayer.Name)
		end
	else
		warn("No nearby player found.")
	end
end, "Movement")
FunctionManager:register("Scare Closest Player", function()

	if not HRP then
		warn("Could not find your HumanoidRootPart.")
		return
	end

	local closestPlayer, closestDistance = nil, math.huge
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= Player and otherPlayer.Character then
			local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			if otherRoot then
				local dist = (otherRoot.Position - HRP.Position).Magnitude
				if dist < closestDistance then
					closestDistance = dist
					closestPlayer = otherPlayer
				end
			end
		end
	end

	if closestPlayer and closestPlayer.Character then
		local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local oldPos = HRP.CFrame
			HRP.CFrame = targetRoot.CFrame + targetRoot.CFrame.lookVector * 2
			HRP.CFrame = CFrame.new(HRP.Position, targetRoot.Position)
			task.wait(0.5)
			HRP.CFrame = oldPos
		end
	else
		warn("No target player nearby.")
	end
end, "Fun")
FunctionManager:register("ESP Toggle", function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character and plr ~= Player then
			local head = plr.Character:FindFirstChild("Head")
			if head then
				local bb = head:FindFirstChild("ESP") or Instance.new("BillboardGui", head)
				bb.Name = "ESP"
				bb.Size = UDim2.new(0,80,0,20)
				bb.AlwaysOnTop = true
				local lbl = bb:FindFirstChild("Name") or Instance.new("TextLabel", bb)
				lbl.Name = "Name"
				lbl.BackgroundTransparency = 1
				lbl.Size = UDim2.new(1,0,1,0)
				lbl.TextColor3 = Color3.new(1,0,0)
				lbl.TextScaled = true
				lbl.Text = plr.Name
				bb.Enabled = espOn
			end
		end
	end
	warn("ESP " .. (espOn and "Enabled" or "Disabled"))
end, "Visual")
FunctionManager:register("JumpPower Slider", function()
	if screenGui:FindFirstChild("JumpPowerModal") then return end

	local overlay = Instance.new("Frame")
	overlay.Name               = "JumpPowerModal"
	overlay.Size               = UDim2.new(1,0,1,0)
	overlay.Position           = UDim2.new(0,0,0,0)
	overlay.BackgroundColor3   = Color3.new(0,0,0)
	overlay.BackgroundTransparency = 0.5
	overlay.ZIndex             = 50
	overlay.Parent             = screenGui


	local panel = Instance.new("Frame")
	panel.Name                  = "JumpPanel"
	panel.Size                  = UDim2.new(0, 300, 0, 100)
	panel.Position              = UDim2.new(0.5, -150, 0.5, -50)
	panel.BackgroundColor3      = Color3.fromRGB(40,40,40)
	panel.BorderSizePixel       = 0
	panel.ZIndex                = 51
	panel.Parent                = overlay


	local closeBtn = Instance.new("TextButton")
	closeBtn.Name               = "Close"
	closeBtn.Size               = UDim2.new(0,60,0,24)
	closeBtn.Position           = UDim2.new(1,-64,0,4)
	closeBtn.Font               = Enum.Font.SourceSansBold
	closeBtn.TextSize           = 14
	closeBtn.Text               = "Close"
	closeBtn.BackgroundColor3   = Color3.fromRGB(150,50,50)
	closeBtn.TextColor3         = Color3.new(1,1,1)
	closeBtn.ZIndex             = 52
	closeBtn.Parent             = panel
	closeBtn.MouseButton1Click:Connect(function()
		overlay:Destroy()
	end)


	local label = Instance.new("TextLabel")
	label.Name                  = "ValueLabel"
	label.Size                  = UDim2.new(1,-8,0,24)
	label.Position              = UDim2.new(0,4,0,4)
	label.BackgroundTransparency= 1
	label.Font                  = Enum.Font.SourceSansBold
	label.TextSize              = 18
	label.TextColor3            = Color3.new(1,1,1)
	label.Text                  = "JumpPower: " .. tostring(Humanoid.JumpPower)
	label.ZIndex                = 52
	label.Parent                = panel


	local track = Instance.new("Frame")
	track.Name                  = "Track"
	track.Size                  = UDim2.new(1,-16,0,20)
	track.Position              = UDim2.new(0,8,0,40)
	track.BackgroundColor3      = Color3.fromRGB(60,60,60)
	track.BorderSizePixel       = 0
	track.ZIndex                = 51
	track.Parent                = panel

	local fill = Instance.new("Frame")
	fill.Name                   = "Fill"
	fill.Size                   = UDim2.new(
		math.clamp((Humanoid.JumpPower - 50)/(200-50),0,1), 0,
		1, 0
	)
	fill.BackgroundColor3       = Color3.fromRGB(100,200,100)
	fill.BorderSizePixel        = 0
	fill.ZIndex                 = 52
	fill.Parent                 = track


	local dragging = false
	local minJ, maxJ = 50, 200

	local function update(x)
		local rel = math.clamp((x - track.AbsolutePosition.X)/track.AbsoluteSize.X, 0,1)
		local v = math.floor(minJ + (maxJ-minJ)*rel)
		Humanoid.JumpPower = v
		label.Text = "JumpPower: "..v
		fill.Size = UDim2.new(rel,0,1,0)
	end

	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			update(i.Position.X)
		end
	end)
	track.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
			update(i.Position.X)
		end
	end)
end, "Movement")



FunctionManager:register("Spin Bot", function()
	spinOn = not spinOn
	if spinOn then
		if not HRP then return warn("No HRP!") end

		
		lockBP = Instance.new("BodyPosition")
		lockBP.Name = "SpinLockBP"
		lockBP.Position = HRP.Position
		lockBP.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		lockBP.P = 1e5
		lockBP.D = 0
		lockBP.Parent = HRP


		spinBAV = Instance.new("BodyAngularVelocity")
		spinBAV.Name = "SpinBAV"
		spinBAV.AngularVelocity = Vector3.new(0, 10000, 0) 
		spinBAV.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
		spinBAV.P = 1e5
		spinBAV.Parent = HRP

		warn("Locked Spin Bot On")
	else
		if spinBAV then
			spinBAV:Destroy()
			spinBAV = nil
		end
		if lockBP then
			lockBP:Destroy()
			lockBP = nil
		end
		warn("Locked Spin Bot Off")
	end
end, "Visual")

FunctionManager:register("TP To Mouse", function()
	if hit then
		HRP.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
		warn("Teleported to mouse")
	end
end, "Movement")
FunctionManager:register("Save Position", function()
	savedCFrame = HRP.CFrame
	warn("Position Saved")
end, "Utility")
FunctionManager:register("Load Position", function()
	if savedCFrame then
		HRP.CFrame = savedCFrame
		warn("Position Loaded")
	else
		warn("No Position Saved")
	end
end, "Utility")


FunctionManager:register("No‑Clip", function()
	noclipOn = not noclipOn

	if noclipOn then
		hoverHeight = HRP.Position.Y

		noclipConn = RunService.RenderStepped:Connect(function()
			for _, part in ipairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end

			local pos = HRP.Position
			HRP.CFrame = CFrame.new(pos.X, hoverHeight, pos.Z)
		end)

		warn("No‑Clip ON (locked at height)")
	else
		if noclipConn then
			noclipConn:Disconnect()
			noclipConn = nil
		end
		for _, part in ipairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
		warn("No‑Clip OFF")
	end
end, "Movement")

FunctionManager:register("DarkDex", function()
	--Maybe works?
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()	
end, "General")
FunctionManager:register("SimpleSpy", function()
	--also maybe works?
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end)
FunctionManager:register("Orbit All Nearby Parts", function()
	local radius = 20
	local height = 3
	local orbitSpeed = 2

	local speaker = Players.LocalPlayer
	local character = speaker.Character or speaker.CharacterAdded:Wait()
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		warn("No HumanoidRootPart found.")
		return
	end

	local origin = root.Position
	local orbitParts = {}

	for _, part in ipairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(workspace.Terrain) then
			local isInCharacter = false

			for _, player in ipairs(Players:GetPlayers()) do
				local char = player.Character
				if char and part:IsDescendantOf(char) then
					isInCharacter = true
					break
				end
			end

			
			if not isInCharacter and (part.Position - origin).Magnitude <= radius then
				if not CollectionService:HasTag(part, "OrbitPart") then
					if part:CanSetNetworkOwnership() then
						part:SetNetworkOwner(speaker)
					else
						warn("Cannot set network owner for part:", part.Name)
					end
					part.CanCollide = false
					CollectionService:AddTag(part, "OrbitPart")
					table.insert(orbitParts, part)
				end
			
			end
		end
	end

	if #orbitParts == 0 then
		warn("No parts found for orbit.")
		return
	end

	local angleOffset = 2 * math.pi / #orbitParts

	for i, part in ipairs(orbitParts) do
		local angle = angleOffset * i

		local startPos = root.Position + Vector3.new(
			math.cos(angle) * radius,
			height,
			math.sin(angle) * radius
		)

		part.Position = startPos

		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro.P = 1e4
		bodyGyro.CFrame = CFrame.new(part.Position, root.Position)
		bodyGyro.Parent = part

		local bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVel.P = 1e4
		bodyVel.Parent = part

		local conn
		conn = RunService.Heartbeat:Connect(function(dt)
			if not root or not root.Parent then
				conn:Disconnect()
				return
			end

			angle += orbitSpeed * dt

			local orbitCenter = root.Position
			local orbitPoint = orbitCenter + Vector3.new(
				math.cos(angle) * radius,
				height,
				math.sin(angle) * radius
			)

			local tangent = Vector3.new(
				-math.sin(angle),
				0,
				math.cos(angle)
			).Unit * orbitSpeed * radius

			bodyVel.Velocity = tangent
			bodyGyro.CFrame = CFrame.new(part.Position, orbitCenter)
			part.Position = orbitPoint
		end)
	end

	warn("Orbiting", #orbitParts, "parts around you.")
end, "Fun")



FunctionManager:register("Invisible", function()
	if not invisRunning then
		invisRunning = true

		repeat task.wait() until Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		OriginalCharacter = Player.Character
		OriginalCharacter.Archivable = true

		InvisibleCharacter = OriginalCharacter:Clone()
		InvisibleCharacter.Name = "InvisibleClone"
		InvisibleCharacter.Parent = workspace

		for _, part in ipairs(InvisibleCharacter:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = (part.Name == "HumanoidRootPart") and 1 or 0.5
				part.CanCollide = false
			end
		end

		local savedCF = OriginalCharacter:FindFirstChild("HumanoidRootPart").CFrame
		local ServerStorage = game:GetService("ServerStorage")
		OriginalCharacter.Parent = ServerStorage

		InvisibleCharacter:FindFirstChild("HumanoidRootPart").CFrame = savedCF
		Player.Character = InvisibleCharacter

		local animate = InvisibleCharacter:FindFirstChild("Animate")
		if animate then
			animate.Disabled = true
			animate.Disabled = false
		end

		local humanoid = InvisibleCharacter:FindFirstChildOfClass("Humanoid")
		if humanoid and not humanoid:FindFirstChildOfClass("Animator") then
			local animator = Instance.new("Animator")
			animator.Parent = humanoid
		end

		humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)

		local cam = workspace.CurrentCamera
		cam.CameraSubject = InvisibleCharacter:FindFirstChildWhichIsA("Humanoid")
		cam.CameraType = Enum.CameraType.Custom


		local Void = workspace.FallenPartsDestroyHeight
		voidConn = game:GetService("RunService").Stepped:Connect(function()
			local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local y = hrp.Position.Y
				if (Void < 0 and y <= Void) or (Void >= 0 and y >= Void) then
					FunctionManager:getFunction("Invisible")() 
				end
			end
		end)

		warn("Invisible ON")

	else
		invisRunning = false

		if voidConn then
			voidConn:Disconnect()
			voidConn = nil
		end

		if InvisibleCharacter then
			InvisibleCharacter:Destroy()
			InvisibleCharacter = nil
		end

		if OriginalCharacter then
			Player.Character = OriginalCharacter
			OriginalCharacter.Parent = workspace

			task.wait()

			local cam = workspace.CurrentCamera
			cam.CameraSubject = OriginalCharacter:FindFirstChildWhichIsA("Humanoid")
			cam.CameraType = Enum.CameraType.Custom

			local hrp = OriginalCharacter:FindFirstChild("HumanoidRootPart")
			if hrp then
				workspace.CurrentCamera.CFrame = hrp.CFrame + Vector3.new(0, 5, 10)
			end

			warn("Invisible OFF")
		else
			warn("Could not restore original character.")
		end
	end
end, "Fun")


FunctionManager:register("Server Hop", function()
	local placeId = game.PlaceId
	TeleportService:Teleport(placeId, Player)
	warn("Hopping to a new server in this place...")
end, "Utility")
FunctionManager:register("Fly", function()
	if not HRP then
		warn("No HumanoidRootPart found; cannot fly.")
		return
	end

	flyingEnabled = not flyingEnabled

	if flyingEnabled then

		flyBG = Instance.new("BodyGyro")
		flyBG.P = 9e4
		flyBG.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
		flyBG.CFrame = HRP.CFrame
		flyBG.Parent = HRP


		flyBV = Instance.new("BodyVelocity")
		flyBV.MaxForce = Vector3.new(9e4, 9e4, 9e4)
		flyBV.Velocity = Vector3.new(0, 0, 0)
		flyBV.Parent = HRP

		flyConn = RunService.Heartbeat:Connect(function()
			local camCFrame = workspace.CurrentCamera.CFrame
			local dir = Vector3.new()

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				dir = dir + camCFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				dir = dir - camCFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				dir = dir - camCFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				dir = dir + camCFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				dir = dir + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				dir = dir - Vector3.new(0, 1, 0)
			end

			if dir.Magnitude > 0 then
				dir = dir.Unit * 50
			end
			flyBV.Velocity = dir
			flyBG.CFrame = CFrame.new(HRP.Position, HRP.Position + camCFrame.LookVector)
		end)

	else
		if flyConn then flyConn:Disconnect() flyConn = nil end
		if flyBG then flyBG:Destroy() flyBG = nil end
		if flyBV then flyBV:Destroy() flyBV = nil end

		
	end
end, "Movement")


FunctionManager:register("Hammer", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/q6yHJSXK", true))()
end, "Troll")

FunctionManager:register("Hitbox Extender", function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/UI_LimbExtender.lua'))()
end, "Troll")
FunctionManager:register("Part Grab", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/v0c0n1337/scripts/refs/heads/main/Unachored_parts_controller_v2.lua.txt"))()
end, "Troll")
FunctionManager:register("Hat Script", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ocfi/Scp-096-Obfuscated/refs/heads/main/obuf"))()
end, "Troll")


--init
updateGrid()
