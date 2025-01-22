require("Aether.core.mouse")

---Input is a Class used to have a unify way to check input state
---@class Input
---@field public class_name string The Class name
---@field public mouse table The Mouse Instance
---@field public states table All inputs pressed
---@field public states_pressed table All inputs just pressed
---@field public states_released table All inputs just released
Input = { class_name = "Input", mouse = {}, states = {}, states_pressed = {}, states_released = {} }

---Input constructor
---@param o table? Table model used for the copy
---@return Input input The Input instance
function Input:new(o)
    o = o or {}
    o.mouse = Mouse:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

---Know if the key is press
---@param id string Key's id
---@return boolean Key's state
function Input:isDown(id)
    local ret = self.states[id]
    if ret == nil then
        return false
    end
    return ret
end

---Know if the key is just pressed
---@param id string Key's id
---@return boolean Key's state
function Input:justPressed(id)
    local ret = self.states_pressed[id]
    if ret == nil then
        return false
    end
    return ret
end

---Know if the key is just released
---@param id string Key's id
---@return boolean Key's state
function Input:justReleased(id)
    local ret = self.states_released[id]
    if ret == nil then
        return false
    end
    return ret
end

---Update the Input class
function Input:update()
    self.states_pressed = {}
    self.states_released = {}
    self.states["mousewheelup"] = false
    self.states["mousewheeldown"] = false
end

---Change the state of a key
---@param id string Key's id
---@param value boolean Key's state value
function Input:changeState(id, value)
    if value == true then
        self.states[id] = true
        self.states_pressed[id] = true
    else
        self.states[id] = false
        self.states_released[id] = true
    end
end
