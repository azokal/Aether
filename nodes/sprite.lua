require("sys.core.node")

---@class Sprite: Node
---@field public class_name string
---@field public pivot Vec2
---@field public asset love.Image
---@field public quad love.Quad
---@field public flip_x boolean
---@field public flip_y boolean
---@field public color Color
Sprite = Node:new { class_name = "Sprite", pivot = nil, asset = nil, quad = nil, flip_x = false, flip_y = false, color = Color:create(1, 1, 1, 1) }

function Sprite:init(path, pivot, mipmaps, linear)
    self.pivot = Vec2:new(pivot)
    self.asset = self.app.resource:loadImage(path, { mipmaps = mipmaps, linear = linear })
    self.quad = love.graphics.newQuad(0, 0, self.asset:getWidth(), self.asset:getHeight(),
        self.asset:getWidth(),
        self.asset:getHeight())
end

function Sprite:draw()
    love.graphics.push("all")
    local gposx, gposy = self:getGlobalPosition()
    local sx, sy = self:getGlobalScale()
    local _, _, qw, qh = self.quad:getViewport()
    --TODO: Check pivot stuff for other position than 0.5 0.5
    local offset = Vec2:create(qw * self.pivot.x, qh * self.pivot.y)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    --offset = offset:rotate(angle)

    if self.flip_x then
        sx = sx * -1
    end

    if self.flip_y then
        sy = sy * -1
    end

    love.graphics.applyTransform(love.math.newTransform(gposx, gposy,
        self:getGlobalRotation() * math.pi / 180,
        sx, sy))
    love.graphics.translate(-offset.x, -offset.y)
    love.graphics.draw(self.asset, self.quad)
    love.graphics.pop()
end
