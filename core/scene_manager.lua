---@class SceneManager
---@field public class_name string
---@field public scenes table[Scene]
---@field public current_scene string
SceneManager = { class_name = "SceneManager", scenes = nil, current_scene = "" }

function SceneManager:new(o)
    o = o or {}
    o.scenes = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SceneManager:addScene(name, scene)
    self.scenes[name] = scene
end

function SceneManager:changeScene(name)
    self.current_scene = name
    self.scenes[name]:init()
end

function SceneManager:getCurrentScene()
    return self.scenes[self.current_scene]
end
