require("Aether.utils")

---@enum Layer
Layer = { BACKGROUND = 0, Layer1 = 1, Layer2 = 2, Layer3 = 3, Layer4 = 4, Layer5 = 5, UI = 6 }

---@class Node
---@field public class_name string
---@field public name string
---@field public transform Transform
---@field public parent Node
---@field public children table[Node]
---@field public active boolean
---@field public app Application
---@field public destroyed boolean
---@field public layer Layer
---@field public zindex number
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

function Node:setPosition(x, y)
    self.transform.position.x = x
    self.transform.position.y = y
end

function Node:setGlobalPosition(x, y)
    local gx, gy = self:getParentsPosition()
    self:setPosition(x - gx, y - gy)
end

function Node:setRotation(angle)
    self.transform.angle = angle
end

function Node:setGlobalRotation(angle)
    local gangle = self:getParentsRotation()
    self:setRotation(angle - gangle)
end

function Node:setScale(x, y)
    self.transform.scale.x = x
    self.transform.scale.y = y
end

function Node:setGlobalScale(x, y)
    local gx, gy = self:getParentsScale()
    self:setScale(x / gx, y / gy)
end

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

function Node:setName(name)
    self.name = string.gsub(name, "/", "_")
end

function Node:getPosition()
    return self.transform.position.x, self.transform.position.y
end

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

function Node:getGlobalPosition()
    local tx, ty = self:getParentsPosition()
    local px, py = self:getPosition()

    return tx + px, ty + py
end

function Node:getRotation()
    return self.transform.angle
end

function Node:getParentsRotation()
    local tangle, tp = 0, self.parent
    while (tp)
    do
        tangle = tangle + tp:getRotation()
        tp = tp.parent
    end
    return tangle
end

function Node:getGlobalRotation()
    return self:getParentsRotation() + self:getRotation()
end

function Node:getScale()
    return self.transform.scale.x, self.transform.scale.y
end

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

function Node:getGlobalScale()
    local tx, ty = self:getParentsScale()
    local px, py = self:getScale()
    return tx * px, ty * py
end

function Node:setLayer(value, children)
    self.layer = value
    if children == true then
        for i = 1, #(self.children), 1 do
            self.children[i]:setLayer(value, children)
        end
    end
end

function Node:setActive(value, children)
    self.active = value
    if children == true then
        for i = 1, #(self.children), 1 do
            self.children[i]:setActive(value, children)
        end
    end
end

function Node:destroy()
    self:setParent(nil)
    self.destroyed = true
    self.app.events:removeAll(self)
end

function Node:update(deltaTime)

end

function Node:draw()
end
