--	Responsible for tilting your character on movement slightly. Gives movement some extra spice
local RunService = game:GetService("RunService")

local hrp = script.Parent:WaitForChild("HumanoidRootPart")
local rootJoint = hrp:WaitForChild("RootJoint")
local humanoid = script.Parent:WaitForChild("Humanoid")

local MAX_TILT = 10
local DEFAULT_ROOT_C0 = rootJoint.C0

local currentTilt = CFrame.new()
RunService.RenderStepped:Connect(function(dt)
	local moveDir = hrp.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
	print(humanoid.MoveDirection)
	
	local angles = CFrame.Angles(math.rad(-moveDir.Z) * MAX_TILT, math.rad(-moveDir.X) * MAX_TILT, 0)
	local formula = 0.2 ^ (1 / (dt * 60))
	currentTilt = currentTilt:Lerp(angles, formula)
	
	rootJoint.C0 = DEFAULT_ROOT_C0 * currentTilt
end)
