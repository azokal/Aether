require("Aether.core.scene_manager")
require("Aether.core.input")
require("Aether.core.resource")
require("Aether.core.database")
require("Aether.core.events")

---Main Aether's Application where we can find all anothers Aether's manager
---@class Aether
---@field public class_name string
---@field public scene_manager? SceneManager
---@field public resource? Resource
---@field public database? Database
---@field public events? Events
---@field public input? Input
---@field public base_width number
---@field public base_height number
Aether = { class_name = "Aether", scene_manager = nil, resource = nil, database = nil, events = nil, input = nil, base_width = 0, base_height = 0, deltaTime = 0 }

Game = Game or require("game.game")

---Aether init
---@param w number The base resolution's width
---@param h number The base resolution's height
function Aether:init(w, h)
    self.scene_manager = SceneManager:new()
    self.input = Input:new()
    self.resource = Resource:new()
    self.database = Database:new()
    self.events = Events:new()
    self.database:init()
    self.base_width = w
    self.base_height = h
end

---Aether load function need to be load in love.load
---@param w number The base resolution's width
---@param h number The base resolution's height
function Aether:load(w, h)
    Aether:init(w, h)
    if Game.load ~= nil then
        Game:load()
    end
    self.deltaTime = 0
end

function love.keypressed(key)
    Aether.input:changeState(key, true)
    if Game.keypressed ~= nil then
        Game:keypressed(key)
    end
end

function love.keyreleased(key)
    Aether.input:changeState(key, false)
    if Game.keyreleased ~= nil then
        Game:keyreleased(key)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    Aether.input:changeState("mouse" .. tostring(button), true)
    if Game.mousepressed ~= nil then
        Game:mousepressed(x, y, button, istouch, presses)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    Aether.input:changeState("mouse" .. tostring(button), false)
    if Game.mousereleased ~= nil then
        Game:mousereleased(x, y, button, istouch, presses)
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        Aether.input:changeState("mousewheelup", true)
    elseif y < 0 then
        Aether.input:changeState("mousewheeldown", true)
    end
    if Game.wheelmoved ~= nil then
        Game:wheelmoved(x, y)
    end
end

function love.update(dt)
    Aether.scene_manager:getCurrentScene():update(dt)
    Aether.input:update()
    Aether.deltaTime = dt
    if Game.update ~= nil then
        Game:update(dt)
    end
end

function love.draw()
    Aether.scene_manager:getCurrentScene():draw()
    if Game.draw ~= nil then
        Game:draw()
    end
end

return Aether
