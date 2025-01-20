require("sys.core.node")

---@class Text: Node
---@field public class_name string
---@field public font love.Font
---@field public text love.Text
---@field public pivot Vec2
Text = Node:new { class_name = "Text", font = nil, text = nil, pivot = nil }

function Text:init(path, text, size, filter)
    self.font = self.app.resource:loadFont(path, size)
    self.font:setFilter(filter, filter)
    self.text = love.graphics.newText(self.font, text)
    self.pivot = Vec2:create(0.5, 0.5)
end

function Text:setText(text)
    self.text:set(text)
end

function Text:draw()
    love.graphics.push("all")
    local gposx, gposy = self:getGlobalPosition()
    local sx, sy = self:getGlobalScale()
    local angle = self:getGlobalRotation()
    local cameras = self.app.scene_manager:getCurrentScene():findNodesOfType("Camera")
    local ratio = cameras[1]:getRatioGameScreen()
    --TODO: Check pivot stuff for other position than 0.5 0.5
    local offset = Vec2:create(self.text:getWidth() * self.pivot.x, self.text:getHeight() * self.pivot.y)

    love.graphics.applyTransform(love.math.newTransform(gposx, gposy,
        self:getGlobalRotation() * math.pi / 180,
        sx, sy))

    love.graphics.translate(-(offset.x), -(offset.y))
    screenX, screenY = love.graphics.transformPoint(0, 0)
    love.graphics.translate(-math.fmod(screenX, 1) / ratio, -math.fmod(screenY, 1) / ratio)
    love.graphics.setFont(self.font)
    love.graphics.draw(self.text, 0, 0)
    love.graphics.pop()
end
