require("Aether.nodes.node")

--- The Sprite node
---@class Sprite: Node
---@field public class_name string The class name
---@field public pivot Vec2 The pivot for the rendering
---@field public asset love.Image The LÖVE Image data
---@field public quad love.Quad The LÖVE Quad data
---@field public flip_x boolean The argument to know if we flip on x
---@field public flip_y boolean The argument to know if we flip on y
---@field public color Color The color used for with a blend multiply for the rendering
Sprite = Node:new { class_name = "Sprite", pivot = nil, asset = nil, quad = nil, flip_x = false, flip_y = false, color = Color:create(1, 1, 1, 1) }

---Init Sprite Node
---@param path string
---@param mipmaps boolean | nil
---@param linear boolean | nil
function Sprite:init(path, mipmaps, linear)
    mipmaps = mipmaps or true
    linear = linear or true
    self.pivot = Vec2:create(0.5, 0.5)
    self.asset = self.app.resource:loadImage(path, { mipmaps = mipmaps, linear = linear })
    self.quad = love.graphics.newQuad(0, 0, self.asset:getWidth(), self.asset:getHeight(),
        self.asset:getWidth(),
        self.asset:getHeight())
end

---Draw Sprite node
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
