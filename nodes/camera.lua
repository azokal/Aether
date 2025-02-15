Aether = Aether or require("Aether.Aether")
require("Aether.nodes.node")

---Camera node use to render scene node with the camera's transform
---@class Camera: Node
---@field class_name string The Class name
---@field batchs love.SpriteBatch[]? The spriteBatch storage
Camera = Node:new({ class_name = "Camera", batchs = nil })

---Draw all nodes relative to the camera transform
---@param nodes Node[] Node to draw
function Camera:drawNodes(nodes)
    --self:resetBatchs()
    love.graphics.push()
    local gposx, gposy = self:getGlobalPosition()
    local angle = self:getGlobalRotation()
    local sx, sy = self:getGlobalScale()
    local w, h = love.graphics.getDimensions()
    local ratio = self:getRatioGameScreen()
    love.graphics.scale(sx * ratio, sy * ratio)
    love.graphics.rotate(-(angle * math.pi / 180))
    local offset = Vec2:create((w / (sx * ratio)) / 2, (h / (sy * ratio)) / 2)
    offset = offset:rotate(angle)
    love.graphics.translate(-gposx + offset.x, -gposy + offset.y)

    for key, value in pairs(Layer) do
        if value ~= 6 and nodes[value] ~= nil then
            for i = 1, #(nodes[value]) do
                if nodes[value][i].active == true then
                    nodes[value][i]:draw()
                end
            end
        end
    end
    --self:drawAllBatchs()
    love.graphics.pop()

    if nodes[Layer.UI] ~= nil then
        love.graphics.push()
        love.graphics.scale(ratio, ratio)

        for i = 1, #(nodes[Layer.UI]), 1 do
            if nodes[Layer.UI][i].active == true then
                nodes[Layer.UI][i]:draw()
            end
        end
        --self:drawAllBatchs()
        love.graphics.pop()
    end
end

---Convert Screen coordinate to World coordinate
---@param screen_position Vec2 The Screen position
---@return Vec2 world_position The World position
function Camera:convertScreenToWorld(screen_position)
    local gposx, gposy = self:getGlobalPosition()
    local w, h = love.graphics.getDimensions()
    local ratio = self:getRatioGameScreen()
    local sx, sy = self:getGlobalScale()
    local offset = Vec2:create((w / (sx * ratio)) / 2, (h / (sy * ratio)) / 2)
    return Vec2:new({
        x = (screen_position.x / (sx * ratio)) - offset.x + gposx,
        y = (screen_position.y / (sy * ratio)) - offset.y + gposy
    })
end

---Get the ratio between the game size and the screen size
---@return number ratio The scale ratio
function Camera:getRatioGameScreen()
    local w, h = love.graphics.getDimensions()
    return h / Aether.base_height
end

---Get the screen's ratio
---@return number ratio The screen's ratio
function Camera:getScreenRatio()
    local w, h = love.graphics.getDimensions()
    return w / h
end

---Get the game screen's ratio
---@return number ratio The game screen's ratio
function Camera:getGameScreenRatio()
    return Aether.base_width / Aether.base_height
end

-- function Camera:resetBatchs()
--     self.batchs = self.batchs or {}
--     for key, value in pairs(self.batchs) do
--         value:clear()
--     end
-- end

-- function Camera:addToBatch(image, quad, position, rotation, scale, offset, color)
--     if self.batchs[image] == nil then
--         self.batchs[image] = love.graphics.newSpriteBatch(image)
--     end
--     self.batchs[image]:setColor(color.r, color.g, color.b, color.a)
--     self.batchs[image]:
--         add(quad, position.x, position.y, rotation * math.pi / 180, scale.x, scale.y, offset.x, offset.y)
-- end

-- function Camera:drawAllBatchs()
--     for key, value in pairs(self.batchs) do
--         love.graphics.draw(value)
--     end
--     self:resetBatchs()
-- end

return Camera
