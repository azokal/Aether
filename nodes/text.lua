require("Aether.nodes.node")
Aether = Aether or require("Aether.Aether")

---The Text node can be use to render text with the node system
---@class Text: Node
---@field public class_name string The class name
---@field public font love.Font? LÖVE font data
---@field public text love.Text? LÖVE Text data
---@field public pivot Vec2 The pivot to be use
Text = Node:new { class_name = "Text", font = nil, text = nil, pivot = nil }

---Init the Text node
---@param path string The font's path
---@param text string The text to display
---@param size number The x value The font size
---@param filter string? The filter to use for the font rendering
function Text:init(path, text, size, filter)
    filter = filter or "linear"
    self.font = Aether.resource:loadFont(path, size)
    self.font:setFilter(filter, filter)
    self.text = love.graphics.newText(self.font, text)
    self.pivot = Vec2:create(0.5, 0.5)
end

---Update display text
---@param text string The text to display
function Text:setText(text)
    self.text:set(text)
end

---Draw Text node
function Text:draw()
    love.graphics.push("all")
    local gposx, gposy = self:getGlobalPosition()
    local sx, sy = self:getGlobalScale()
    local angle = self:getGlobalRotation()
    ---@type Camera[]
    local cameras = Aether.scene_manager:getCurrentScene():findNodesOfType("Camera")
    local ratio = cameras[1]:getRatioGameScreen()
    --TODO: Check pivot stuff for other position than 0.5 0.5
    local offset = Vec2:create(self.text:getWidth() * self.pivot.x, self.text:getHeight() * self.pivot.y)

    love.graphics.applyTransform(love.math.newTransform(gposx, gposy,
        self:getGlobalRotation() * math.pi / 180,
        sx, sy))

    love.graphics.translate(-(offset.x), -(offset.y))
    local screenX, screenY = love.graphics.transformPoint(0, 0)
    love.graphics.translate(-math.fmod(screenX, 1) / ratio, -math.fmod(screenY, 1) / ratio)
    love.graphics.setFont(self.font)
    love.graphics.draw(self.text, 0, 0)
    love.graphics.pop()
end

return Text
