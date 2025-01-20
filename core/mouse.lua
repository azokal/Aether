---@class Mouse
---@field public class_name string
Mouse = { class_name = "Mouse" }

function Mouse:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Mouse:setVisual(img, ox, oy)
    if img == nil then
        love.mouse.setCursor()
    else
        love.mouse.setCursor(love.mouse.newCursor(img, ox or 0, oy or 0))
    end
end

function Mouse:getPosition()
    return love.mouse.getPosition()
end

function Mouse:confine(isTrue)
    love.mouse.setGrabbed(isTrue)
end

function Mouse:isConfined()
    return love.mouse.isGrabbed()
end
