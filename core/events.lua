---Events is a observer design pattern Class ready to use
---@class Events
---@field public class_name string The class name
---@field public data table? Store the different subscribers by channel
Events = { class_name = "Events", data = nil }

---Events constructor
---@param o table? Table model used for the copy
---@return Events events The Events instance
function Events:new(o)
    o = o or {}
    o.data = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Listen to a channel
---@param channel integer Channel to subscribe
---@param entity table Entity who subscribe
---@param func function Function to call when invoke. The must take a table as argument
function Events:listen(channel, entity, func)
    if self.data[channel] == nil then
        self.data[channel] = {}
    end
    if self.data[channel][entity] == nil then
        self.data[channel][entity] = {}
    end
    table.insert(self.data[channel][entity], func)
end

---Invoke a channel
---@param channel integer Channel to invoke
---@param args table Arguments for the function
function Events:invoke(channel, args)
    if self.data[channel] == nil then
        return
    end
    for key, value in pairs(self.data[channel]) do
        for k, v in pairs(value) do
            v(key, args)
        end
    end
end

---Remove a function from a entity in the channel
---@param channel integer Subscribed channel
---@param entity table Subscribed Entity
---@param func function Function to remove
function Events:deafen(channel, entity, func)
    if self.data[channel] == nil then
        return
    end
    if self.data[channel][entity] == nil then
        return
    end
    local found, key = table.contains(self.data[channel][entity], func)
    if found then
        table.remove(self.data[channel][entity], key)
    end
end

---Remove the entity from a chennel
---@param channel integer Subscribed channel
---@param entity table Entity to remove
function Events:remove(channel, entity)
    if self.data[channel] == nil then
        return
    end
    local found, key = table.contains(self.data[channel], entity)
    if found then
        table.remove(self.data[channel], key)
    end
end

---Remove a entity from all channel
---@param entity table Entity to remove
function Events:removeAll(entity)
    for key, value in pairs(self.data) do
        local found, index = table.contains(value, entity)
        if found then
            table.remove(value, index)
        end
    end
end

---Reset the Class' state
function Events:reset()
    self.data = {}
end

return Events
