require("Aether.nodes.node")

---Camera node use to render scene node with the camera's transform
---@class Camera: Node
---@field class_name string The Class name
Camera = Node:new({ class_name = "Camera" }, nil)

---Draw all node given with the camera's transform
---@param nodes Node[] Node to draw
function Camera:drawNodes(nodes)
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

    love.graphics.pop()

    if nodes[Layer.UI] ~= nil then
        love.graphics.push()
        love.graphics.scale(ratio, ratio)

        for i = 1, #(nodes[Layer.UI]), 1 do
            if nodes[Layer.UI][i].active == true then
                nodes[Layer.UI][i]:draw()
            end
        end
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
---@return number The scale ratio
function Camera:getRatioGameScreen()
    local w, h = love.graphics.getDimensions()
    return h / self.app.base_height
end
