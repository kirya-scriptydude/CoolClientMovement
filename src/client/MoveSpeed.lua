-- A singleton module that handles movement speed on humanoid

local function newEffectDescription(strength : number, duration : number)
    return {
        ["Strength"] = strength,
        ["Duration"] = duration,
        ["CurrentDuration"] = duration
    }
end

local plr = game:GetService("Players").LocalPlayer
local MoveSpeed = {}

MoveSpeed.BaseSpeed = 16
local activeEffects = {}

function MoveSpeed.setEffect(name, strength, duration)
    local effectDesc = newEffectDescription(strength, duration)
    activeEffects[name] = effectDesc
end

-- Update an effect if it exists without creating it.
function MoveSpeed.updateEffect(name)
    local effect = activeEffects[name]
    if effect then
        effect.CurrentDuration = effect.Duration
    end
end

function MoveSpeed.hasEffect(name)
    return activeEffects[name] ~= nil
end

-- Cleanse player from a certain effect
function MoveSpeed.cleanseEffect(name)
    activeEffects[name] = nil
end

-- Function that's hooked to .RenderStepped that handles all the stuff.
function MoveSpeed.renderStep(dt)
end

game:GetService("RunService").RenderStepped:Connect(MoveSpeed.renderStep)
return MoveSpeed