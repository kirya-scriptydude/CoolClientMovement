--  A script that handles directional walking animation.

--  Set your animationId's here
local ANIMATION_WALK_FORWARD = "rbxassetid://73101340682900"
local ANIMATION_WALK_LEFT = "rbxassetid://80073520906101"
local ANIMATION_WALK_RIGHT = "rbxassetid://104324869091371"

local RunService = game:GetService("RunService")

local char = game:GetService("Players").LocalPlayer.Character

local _animForward = Instance.new("Animation")
_animForward.AnimationId = ANIMATION_WALK_FORWARD
local _animLeft = Instance.new("Animation")
_animLeft.AnimationId = ANIMATION_WALK_LEFT
local _animRight = Instance.new("Animation")
_animRight = ANIMATION_WALK_RIGHT

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

RunService:BindToRenderStep("animation_directionalwalk", Enum.RenderPriority.Character.Value + 1, function()
end)