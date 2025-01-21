require("Aether.nodes.node")

---The Rectangle node can be use to display a LÖVE Rectangle with the node system
---@class Rectangle: Node
---@field public class_name string The class name
---@field public size Vec2 The rectangle's size
---@field public type "fill"|"line" The fill mode for LÖVE function
---@field public fill_amount number The fill amount
---@field public pivot Vec2 The pivot for the rendering
---@field public color Color The rectangle's color
Rectangle = Node:new { class_name = "Rectangle", size = nil, type = "fill", fill_amount = 1, pivot = nil, color = nil }

---Init Rectangle Node
---@param width number The rectangle's width
---@param height number The rectangle's height
---@param type "fill"|"line" The fill mode for LÖVE function
---@param fill_amount number The fill amount
---@param color Color The rectangle's color
function Rectangle:init(width, height, type, fill_amount, color)
    self.size = Vec2:create(width, height)
    self.type = type
    self.fill_amount = fill_amount
    self.pivot = Vec2:create(0.5, 0.5)
    self.color = Color:create(color.r, color.g, color.b, color.a)
end

---Draw Rectangle node
function Rectangle:draw()
    love.graphics.push("all")
    local gposx, gposy = self:getGlobalPosition()
    local sx, sy = self:getGlobalScale()
    --TODO: Check pivot stuff for other position than 0.5 0.5
    local offset = Vec2:create(
        ((self.size.x * self.pivot.x) * self.fill_amount) + ((self.size.x * self.pivot.x) * (1 - self.fill_amount)),
        self.size.y * self.pivot.y)

    offset = offset:rotate(self.transform.angle)
    love.graphics.applyTransform(love.math.newTransform(gposx, gposy,
        self:getGlobalRotation() * math.pi / 180,
        sx, sy))
    love.graphics.translate(-offset.x, -offset.y)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.rectangle(self.type, 0, 0, self.size.x * self.fill_amount, self.size.y)
    love.graphics.pop()
end
