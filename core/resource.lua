---@class Resource
Resource = { class_name = "Resource", cache = {} }

function Resource:new(o, w, h)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

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
