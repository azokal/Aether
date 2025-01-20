Effects = { class_name = "Effects", datas = nil }

function Effects:new(o)
    o = o or {}
    o.datas = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

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

function Effects:remove(effect)
    local found, key = table.contains(self.datas, effect)
    if found then
        table.remove(self.datas, key)
    end
end

function Effects:get(class_name)
    local ret = {}
    for key, value in pairs(self.datas) do
        if value.class_name == class_name then
            table.insert(ret, value)
        end
    end
    return ret
end

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
