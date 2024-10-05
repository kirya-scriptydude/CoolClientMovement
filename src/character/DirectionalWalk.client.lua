--  A script that handles directional walking animation.

--  Set your animationId's here
local ANIMATION_WALK_FORWARD = "rbxassetid://73101340682900"
local ANIMATION_WALK_LEFT = "rbxassetid://80073520906101"
local ANIMATION_WALK_RIGHT = "rbxassetid://104324869091371"

local RunService = game:GetService("RunService")

local char = game:GetService("Players").LocalPlayer.Character
local hum : Humanoid = char:WaitForChild("Humanoid")
local animator = hum:WaitForChild("Animator")
local hrp : Part = char:WaitForChild("HumanoidRootPart")

local _animForward = Instance.new("Animation")
_animForward.AnimationId = ANIMATION_WALK_FORWARD
local _animLeft = Instance.new("Animation")
_animLeft.AnimationId = ANIMATION_WALK_LEFT
local _animRight = Instance.new("Animation")
_animRight.AnimationId = ANIMATION_WALK_RIGHT

-- Animations based on their movement vector. For example: Walk Forward is 0,0,-1 because it's forward vector.
local animationVector = {
    [tostring(Vector3.new(0,0,-1))] = _animForward,
    [tostring(Vector3.new(1,0,0))] = _animLeft,
    [tostring(Vector3.new(-1,0,0))] = _animRight,
}

--disable default normal walk animation (dirty hacky solution for the time being)
local animScript = char:WaitForChild("Animate")
animScript.run.RunAnim.AnimationId = "rbxassetid://0"
animScript.walk.WalkAnim.AnimationId = "rbxassetid://0"

local function stringToVector3(str)
    return Vector3.new(str:match("(.+), (.+), (.+)"))
end

local function searchInstanceTableByName(table, name)
    local instance

    for i,v in pairs(table) do
        if instance then continue end

        if v.Name == name then
            instance = v
        end
    end

    return instance
end

local activeAnims = {}
--already loaded animation tracks into humanoid's animator
local animTracks = {}
for i,v in pairs(animationVector) do
    local track = animator:LoadAnimation(v)
    track.Name = v.AnimationId
    table.insert(animTracks, track)
end


RunService:BindToRenderStep("animation_directionalwalk", Enum.RenderPriority.Character.Value + 1, function()
    for i,v in pairs(animationVector) do
        local vector = stringToVector3(i)
        local dot = vector:Dot(hrp.CFrame:VectorToObjectSpace(hum.MoveDirection))

        local weight = math.clamp(dot, 0, 1)
        activeAnims[i] = weight
    end
end)

RunService.RenderStepped:Connect(function(dt)
    local humState = hum:GetState()
    local moveMagnitude = hum.MoveDirection.Magnitude

    if humState == Enum.HumanoidStateType.Running and moveMagnitude > 0 then
        --we are moving, animating the player
        for i,v in pairs(activeAnims) do
            local track : AnimationTrack = searchInstanceTableByName(animTracks, animationVector[i].AnimationId)
            if not track then continue end
            
            if not track.IsPlaying then track:Play() end

            track:AdjustWeight(v)

            if v == 0 then
                track:Stop()
                continue
            end
        end

    else
        --if we are not moving, stop everything
        for i,v in pairs(animTracks) do
            v:Stop()
        end
    end
end)