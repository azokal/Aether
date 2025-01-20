require("Aether.nodes.node")

---@class Rectangle: Node
---@field public class_name string
---@field public size Vec2
---@field public type string
---@field public fill_amount number
---@field public pivot Vec2
---@field public color Color
Rectangle = Node:new { class_name = "Rectangle", size = nil, type = "fill", fill_amount = 1, pivot = nil, color = nil }

function Rectangle:init(width, height, type, fill_amount, pivot_x, pivot_y, color)
    self.size = Vec2:create(width, height)
    self.type = type
    self.fill_amount = fill_amount
    self.pivot = Vec2:create(pivot_x, pivot_y)
    self.color = Color:create(color.r, color.g, color.b, color.a)
end

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
