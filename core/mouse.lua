---Mouse is a Class used to encapsulate LÖVE mouse function
---@class Mouse
---@field public class_name string The class name
Mouse = { class_name = "Mouse" }

---Mouse Constructor
---@param o table? Table model used for the copy
---@return Mouse o The Mouse instance
function Mouse:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Set the cursor's visual
---@param img string? The visual's path
---@param ox number? The x offset
---@param oy number? The y offset
function Mouse:setVisual(img, ox, oy)
    if img == nil then
        love.mouse.setCursor()
    else
        love.mouse.setCursor(love.mouse.newCursor(img, ox or 0, oy or 0))
    end
end

---Get mouse position
---@return number x The mouse position on x axis
---@return number y The mouse position on y axis
function Mouse:getPosition()
    return love.mouse.getPosition()
end

---Confine the mouse in the window
---@param isTrue boolean Set the confine's state
function Mouse:confine(isTrue)
    love.mouse.setGrabbed(isTrue)
end

---Get the confine's state
---@return boolean is_confined The confine's state
function Mouse:isConfined()
    return love.mouse.isGrabbed()
end

return Mouse
