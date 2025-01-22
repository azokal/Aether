---The SceneManager is a Class used to have to manipulate scene and define the current one
---@class SceneManager
---@field public class_name string The Class Name
---@field public scenes { [string]: Scene }|nil All scenes track by the SceneManager
---@field public current_scene string Name of the current scene
SceneManager = { class_name = "SceneManager", scenes = nil, current_scene = "" }

---SceneManager constructor
---@param o table Table model used for the copy
---@return SceneManager o The instanciate SceneManager
function SceneManager:new(o)
    o = o or {}
    o.scenes = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Add Scene to the SceneManager
---@param name string The scene's name. It is used as a key
---@param scene Scene Scene object
function SceneManager:addScene(name, scene)
    self.scenes[name] = scene
end

---Change the current Scene
---@param name string The scene's name for the new current scene
function SceneManager:changeScene(name)
    self.current_scene = name
    self.scenes[name]:init()
end

---Get the current scene
---@return Scene current_scene The current scene
function SceneManager:getCurrentScene()
    return self.scenes[self.current_scene]
end
