require("sys.core.mouse")

Input = { class_name = "Input", mouse = {}, states = {}, states_pressed = {}, states_released = {} }

function Input:new(o)
    o = o or {}
    o.mouse = Mouse:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

function Input:isDown(id)
    local ret = self.states[id]
    if ret == nil then
        return false
    end
    return ret
end

function Input:justPressed(id)
    local ret = self.states_pressed[id]
    if ret == nil then
        return false
    end
    return ret
end

function Input:justReleased(id)
    local ret = self.states_released[id]
    if ret == nil then
        return false
    end
    return ret
end

function Input:update()
    self.states_pressed = {}
    self.states_released = {}
    self.states["mousewheelup"] = false
    self.states["mousewheeldown"] = false
end

function Input:changeState(id, value)
    if value == true then
        self.states[id] = true
        self.states_pressed[id] = true
    else
        self.states[id] = false
        self.states_released[id] = true
    end
end
