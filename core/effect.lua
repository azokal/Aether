Effect = { class_name = "Effect", channel = nil, visible = false, unique = false }

function Effect:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Effect:init(channel, visible, unique)
    self.channel = channel
    self.visible = visible
    self.unique = unique
end

function Effect:getValues()

end

function Effect:setValues(arg)

end

function Effect:exec(me, channel, args)

end
