require("Aether.utils")

---@enum Layer Rendering Layer
Layer = { BACKGROUND = 0, Layer1 = 1, Layer2 = 2, Layer3 = 3, Layer4 = 4, Layer5 = 5, UI = 6 }

---The base Node
---@class Node
---@field public class_name string The Class' name
---@field public name string The Node's name
---@field public transform Transform|nil The Node's transform
---@field public parent Node|nil The Node's parent
---@field public children Node[]|nil The Node's children
---@field public active boolean The Node's active state
---@field public app Application|nil The Aether's application instance
---@field public destroyed boolean The Node's destroy state
---@field public layer Layer The Node's render layer
---@field public zindex number The Node's z-index
Node = {
    class_name = "Node",
    name = "",
    transform = nil,
    parent = nil,
    children = nil,
    active = true,
    app = nil,
    destroyed = false,
    time_destroyed = 0,
    layer =
        Layer.Layer1,
    zindex = 0
}

---Node constructor
---@param o table|nil The node's model to make a copy
---@param app Application|nil The Aether's application instance
---@return Node o The instanciate node
function Node:new(o, app)
    o = o or {}
    o.name = "node" .. os.clock()
    o.transform = Transform:new()
    o.children = {}
    o.app = app
    setmetatable(o, self)
    self.__index = self
    return o
end

---Set the node's local position
---@param x number The position on the X axis
---@param y number The position on the Y axis
function Node:setPosition(x, y)
    self.transform.position.x = x
    self.transform.position.y = y
end

---Set the node's global position
---@param x number The position on the X axis
---@param y number The position on the Y axis
function Node:setGlobalPosition(x, y)
    local gx, gy = self:getParentsPosition()
    self:setPosition(x - gx, y - gy)
end

---Set the node's local rotation
---@param angle number The angle used for the rotate
function Node:setRotation(angle)
    self.transform.angle = angle
end

---Set the node's global rotation
---@param angle number The angle used for the rotate
function Node:setGlobalRotation(angle)
    local gangle = self:getParentsRotation()
    self:setRotation(angle - gangle)
end

---Set the node's local scale
---@param x number The scale on the X axis
---@param y number The scale on the Y axis
function Node:setScale(x, y)
    self.transform.scale.x = x
    self.transform.scale.y = y
end

---Set the node's global scale
---@param x number The scale on the X axis
---@param y number The scale on the Y axis
function Node:setGlobalScale(x, y)
    local gx, gy = self:getParentsScale()
    self:setScale(x / gx, y / gy)
end

---Set Node's parent
---@param p Node|nil The futur parent
function Node:setParent(p)
    if p == nil then
        if self.parent ~= nil then
            for i = 1, #(self.parent.children) do
                if self.parent.children[i] == self then
                    table.remove(self.parent.children, i)
                    break
                end
            end
        end
    else
        table.insert(p.children, self)
    end
    self.parent = p
end

---Set Node's name
---@param name string the chosen name
function Node:setName(name)
    self.name = string.gsub(name, "/", "_")
end

---Get Node's local position
---@return number x The position on the X axis
---@return number y The position on the Y axis
function Node:getPosition()
    return self.transform.position.x, self.transform.position.y
end

---@private
function Node:getParentsPosition()
    local tx, ty, tp = 0, 0, self.parent
    while (tp)
    do
        tx = tx + tp.transform.position.x
        ty = ty + tp.transform.position.y
        tp = tp.parent
    end
    return tx, ty
end

---Get Node's global position
---@return number x The position on the X axis
---@return number y The position on the Y axis
function Node:getGlobalPosition()
    local tx, ty = self:getParentsPosition()
    local px, py = self:getPosition()

    return tx + px, ty + py
end

---Get node's local rotation angle
---@return number angle The angle
function Node:getRotation()
    return self.transform.angle
end

---@private
function Node:getParentsRotation()
    local tangle, tp = 0, self.parent
    while (tp)
    do
        tangle = tangle + tp:getRotation()
        tp = tp.parent
    end
    return tangle
end

---Get node's global rotation angle
---@return number angle The angle
function Node:getGlobalRotation()
    return self:getParentsRotation() + self:getRotation()
end

---Get Node's local scale
---@return number x The scale on the X axis
---@return number y The scale on the Y axis
function Node:getScale()
    return self.transform.scale.x, self.transform.scale.y
end

---@private
function Node:getParentsScale()
    local tx, ty, tp = 1, 1, self.parent
    while (tp)
    do
        tx = tx * tp.transform.scale.x
        ty = ty * tp.transform.scale.y
        tp = tp.parent
    end
    return tx, ty
end

---Get Node's global scale
---@return number x The scale on the X axis
---@return number y The scale on the Y axis
function Node:getGlobalScale()
    local tx, ty = self:getParentsScale()
    local px, py = self:getScale()
    return tx * px, ty * py
end

---Set Node's layer
---@param value Layer The choosen layer
---@param children boolean Apply to all children
function Node:setLayer(value, children)
    self.layer = value
    if children == true then
        for i = 1, #(self.children), 1 do
            self.children[i]:setLayer(value, children)
        end
    end
end

---Set Node's active state
---@param value boolean The choosen active state
---@param children boolean Apply to all children
function Node:setActive(value, children)
    self.active = value
    if children == true then
        for i = 1, #(self.children), 1 do
            self.children[i]:setActive(value, children)
        end
    end
end

---Destroy the Node and let be handle by the scene
function Node:destroy()
    self:setParent(nil)
    self.destroyed = true
    self.app.events:removeAll(self)
end

---Placeholder function to update the node in child
---@param deltaTime number The delta time between frame
function Node:update(deltaTime)

end

---Placeholder function to draw the node in child
function Node:draw()
end
