---Resource is a Class used to load resources and to keep a cache of it.
---@class Resource
---@field public class_name string The Class name
---@field public cache table Cache's table
Resource = { class_name = "Resource", cache = {} }

---Resource constructor
---@param o table? Table model used for the copy
---@return Resource o The Resource instance
function Resource:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Load Image
---@param path string The image path
---@param settings table The LÖVE setting for newImage
---@return love.Image? image The loaded asset
function Resource:loadImage(path, settings)
    local info = love.filesystem.getInfo(path)
    if info == nil then
        print("Resource: Can't find asset: " .. path)
        return nil
    end
    if self.cache[path] == nil then
        self.cache[path] = love.graphics.newImage(path, settings)
    end
    return self.cache[path]
end

---Load font
---@param path string The font path
---@param size number The font size. It's used to create a key for the cache.
---@return love.Font? image The loaded asset
function Resource:loadFont(path, size)
    local info = love.filesystem.getInfo(path)
    if info == nil then
        print("Resource: Can't find asset: " .. path)
        return nil
    end
    if self.cache[path .. tostring(size)] == nil then
        self.cache[path .. tostring(size)] = love.graphics.newFont(path, size)
    end
    return self.cache[path .. tostring(size)]
end
