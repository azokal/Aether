---Effect is Class used to give more logic to node following the strategy design pattern
---@class Effect
---@field public class_name string The class name
---@field public channel? number The Flag used to identify on which channel the exec function to be called. Can add multiple channel with bit.op
---@field public visible boolean Is the effect's visible state
---@field public unique boolean Is the effect must be unique
Effect = { class_name = "Effect", channel = nil, visible = false, unique = false }

---Effect constructor
---@param o table? Table model used for the copy
---@return Effect effect The Effect instance
function Effect:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Init Effect
---@param channel number The Flag used to identify on which channel the exec function to be called. Can add multiple channel with bit.op
---@param visible boolean Is the effect's visible state
---@param unique boolean Is the effect must be unique
function Effect:init(channel, visible, unique)
    self.channel = channel
    self.visible = visible
    self.unique = unique
end

---Placeholder to return effect's values
---@return table values Effect's values
function Effect:getValues()
    return {}
end

---Placeholder to set effect's values
---@param arg table Effect's values to set
function Effect:setValues(arg)

end

---Exec Effect logic
---@param me Node The node that trigger the exec
---@param channel number The channel triggered
---@param args table The exec args
---@return table? values Exec's return
function Effect:exec(me, channel, args)
    return nil
end

return Effect
