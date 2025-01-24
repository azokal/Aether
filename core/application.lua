require("Aether.core.scene_manager")
require("Aether.core.input")
require("Aether.core.resource")
require("Aether.core.database")
require("Aether.core.events")

---Main Aether's Application where we can find all anothers Aether's manager
---@class Application
---@field public class_name string
---@field public scene_manager? SceneManager
---@field public resource? Resource
---@field public database? Database
---@field public events? Events
---@field public input? Input
---@field public base_width number
---@field public base_height number
Application = { class_name = "Application", scene_manager = nil, resource = nil, database = nil, events = nil, input = nil, base_width = 0, base_height = 0 }

---Application constructor
---@param o table? Table model used for the copy
---@param w number The base resolution's width
---@param h number The base resolution's height
---@return Application app Application instance
function Application:new(o, w, h)
    o = o or {}
    o.scene_manager = SceneManager:new()
    o.input = Input:new()
    o.resource = Resource:new()
    o.database = Database:new()
    o.events = Events:new()
    o.database:init()
    o.base_width = w
    o.base_height = h
    setmetatable(o, self)
    self.__index = self
    return o
end
