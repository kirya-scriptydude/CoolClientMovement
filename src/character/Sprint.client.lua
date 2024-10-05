--  A script that handles sprinting/running by pressing 2 movement buttons in a quick succession

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local char = game:GetService("Players").LocalPlayer.Character
local hum = char:WaitForChild("Humanoid")

local VALID_KEYCODES = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D
}
local INPUT_TIME_WINDOW = 0.5
local SPRINT_MULTIPLIER = 1.5

local lastInput = Enum.KeyCode.W
local lastInputTick = tick()
local holdingSprint = false

--  table that contains info about if valid input is hold or not. 
local keycodeDown = {}
for i,v in pairs(VALID_KEYCODES) do
    keycodeDown[v.Name] = false
end

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if keycodeDown[input.KeyCode.Name] ~= nil then
        keycodeDown[input.KeyCode.Name] = true

        local curTick = tick()
        if curTick - lastInputTick < INPUT_TIME_WINDOW and lastInput == input.KeyCode then
            --initialize sprinting
            print("yipee")
            holdingSprint = true
        end

        lastInput = input.KeyCode
        lastInputTick = curTick
    end
end)

UIS.InputEnded:Connect(function(input, processed)
    if processed then return end

    if keycodeDown[input.KeyCode.Name] ~= nil then
        keycodeDown[input.KeyCode.Name] = false

        local isHoldingInput = false
        for i,v in pairs(keycodeDown) do
            if v == true then
                isHoldingInput = v
            end
            
            if isHoldingInput then continue end
        end

        -- if there is no button holding direction keys - stop sprinting.
        if not isHoldingInput then
            holdingSprint = false
        end
    end
end)

-- Handle speeding character up when holdingSprint == true
RunService.Heartbeat:Connect(function(dt)
    if holdingSprint then
        hum.WalkSpeed = 16 * SPRINT_MULTIPLIER
    else
        hum.WalkSpeed = 16
    end
    print(keycodeDown)
end)