---Effects is a manager for Effet
---@class Effects
---@field public class_name string The class name
---@field public datas? table Effect Storage
Effects = { class_name = "Effects", datas = nil }

---Effects constructor
---@param o table? Table model used for the copy
---@return Effects effects The Effects instance
function Effects:new(o)
    o = o or {}
    o.datas = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Add a Effect
---@param effect Effect The added Effect
function Effects:add(effect)
    local ret = self:get(effect.class_name)
    if #ret >= 1 then
        if ret[1].unique == true then
            ret[1]:setValues(effect:getValues())
            return
        end
    end
    table.insert(self.datas, effect)
end

---Remove a Effect
---@param effect Effect The removed Effect
function Effects:remove(effect)
    local found, key = table.contains(self.datas, effect)
    if found then
        table.remove(self.datas, key)
    end
end

---Get a Effect by his class name
---@param class_name string The class name
function Effects:get(class_name)
    local ret = {}
    for key, value in pairs(self.datas) do
        if value.class_name == class_name then
            table.insert(ret, value)
        end
    end
    return ret
end

---Call the exec function from a effect channel
---@param me Node The node that store the Effects
---@param channel number The Flag used to identify which effect to trigger
---@param arg table Argument passed to func exec
---@return table values The return of the exec value
function Effects:exec(me, channel, arg)
    local ret = {}
    for key, value in pairs(self.datas) do
        if bit.band(value.channel, channel) ~= 0 then
            local r = value:exec(me, channel, arg)
            table.insert(ret, r)
        end
    end
    return ret
end
