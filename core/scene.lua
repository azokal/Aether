---@class Scene
---@field public class_name string
---@field public nodes table[Node]
---@field public app Application
Scene = { class_name = "Scene", nodes = nil, app = nil, to_destroy_node = nil }

function Scene:new(o, app)
    o = o or {}
    o.nodes = {}
    o.to_destroy_node = {}
    o.app = app
    setmetatable(o, self)
    self.__index = self
    return o
end

function Scene:addNode(node)
    local found, _ = table.contains(self.nodes, node)
    if not found then
        table.insert(self.nodes, node)
        for i = 1, #(node.children), 1 do
            self:addNode(node.children[i])
        end
    end
end

function Scene:removeNode(node)
    for i = 1, #(self.nodes), 1 do
        if self.nodes[i] == node then
            table.remove(self.nodes, i)
            break
        end
    end
    for i = 1, #(node.children), 1 do
        self:removeNode(node.children[i])
    end
end

local function recFindNode(token, nodes)
    local head = table.remove(token, 1)
    for i = 1, #nodes do
        if head == nodes[i].name then
            if #token == 0 then
                return nodes[i]
            else
                return recFindNode(token, nodes[i].children)
            end
        end
    end
    return nil
end

function Scene:findNode(path)
    local token = path:split("/")
    local base_nodes = {}
    local t = path.sub(1, 1)
    if path.sub(1, 1) == "/" then
        for i = 1, #(self.nodes) do
            if self.nodes[i].parent == nil then
                table.insert(base_nodes, self.nodes[i])
            end
        end
    else
        base_nodes = self.nodes
    end
    return recFindNode(token, base_nodes)
end

function Scene:update(deltaTime)
    for i = 1, #(self.nodes) do
        if self.nodes[i].active == true and self.nodes[i].destroyed == false then
            self.nodes[i]:update(deltaTime)
        end
    end

    local tmp = {}
    for i = 1, #(self.nodes) do
        if self.nodes[i].destroyed == true then
            self.nodes[i].active = false
            table.insert(tmp, self.nodes[i])
        end
    end

    for i = 1, #tmp do
        if tmp[i].time_destroyed == 2 then
            -- local found, key = table.contains(self.nodes)
            -- if found then
            self:removeNode(tmp[i])
            --end
        else
            tmp[i].time_destroyed = tmp[i].time_destroyed + 1
        end
    end

    -- print("--- Current Scene ---")
    -- print("Nodes in tree: " .. #(self.nodes))
    -- for i = 1, #(self.nodes) do
    --     print(self.nodes[i])
    --     print("parent: " .. tostring(self.nodes[i].parent))
    --     print("type: " .. self.nodes[i].class_name)
    --     print("------------------")
    -- end
end

function Scene:findNodesOfType(type)
    local base_nodes = {}
    for i = 1, #(self.nodes) do
        if self.nodes[i].class_name == type then
            table.insert(base_nodes, self.nodes[i])
        end
    end
    return base_nodes
end

function Scene:findRootNodes()
    local base_nodes = {}
    for i = 1, #(self.nodes) do
        if self.nodes[i].parent == nil then
            table.insert(base_nodes, self.nodes[i])
        end
    end
    return base_nodes
end

function Scene:getNodeOrderByOrder()
    local orderNodeByLayer = {}
    for i = 1, #(self.nodes), 1 do
        if orderNodeByLayer[self.nodes[i].layer] == nil then
            orderNodeByLayer[self.nodes[i].layer] = { self.nodes[i] }
        else
            local added = false
            for j = 1, #(orderNodeByLayer[self.nodes[i].layer]), 1 do
                if self.nodes[i].zindex <= orderNodeByLayer[self.nodes[i].layer][j].zindex then
                    table.insert(orderNodeByLayer[self.nodes[i].layer], j, self.nodes[i])
                    added = true
                    break
                end
            end
            if added == false then
                table.insert(orderNodeByLayer[self.nodes[i].layer], self.nodes[i])
            end
        end
    end
    return orderNodeByLayer
end

function Scene:draw()
    local cameras = self:findNodesOfType("Camera")

    if #cameras == 0 then
        for i = 1, #(self.nodes) do
            if self.nodes[i].active == true and self.nodes[i].destroyed == false then
                self.nodes[i]:draw()
            end
        end
    else
        local orderNodeByLayer = self:getNodeOrderByOrder()

        for i = 1, #cameras, 1 do
            cameras[1]:drawNodes(orderNodeByLayer)
        end
    end
end

function Scene:init()
    app.events:reset()
end
