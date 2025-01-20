---@class Vec2
---@field public class_name string
---@field public x number
---@field public y number
Vec2 = { class_name = "Vec2", x = 0, y = 0 }

function Vec2:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Vec2:create(x, y)
    return Vec2:new({ x = x, y = y })
end

function Vec2:magnitude()
    return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
end

function Vec2:normalized()
    local t = Vec2:new()
    local d = self:magnitude()
    if d == 0 then
        return t
    end
    t.x = self.x / d
    t.y = self.y / d
    return t
end

function Vec2:__add(right)
    local t = Vec2:new()
    if type(right) == "table" then
        t.x = self.x + right.x
        t.y = self.y + right.y
    end
    if type(right) == "number" then
        t.x = self.x + right
        t.y = self.y + right
    end
    return t
end

function Vec2:__sub(right)
    local t = Vec2:new()
    if type(right) == "table" then
        t.x = self.x - right.x
        t.y = self.y - right.y
    end
    if type(right) == "number" then
        t.x = self.x - right
        t.y = self.y - right
    end
    return t
end

function Vec2:__mul(const)
    local t = Vec2:new()
    t.x = self.x * const
    t.y = self.y * const
    return t
end

function Vec2:__div(const)
    local t = Vec2:new()
    t.x = self.x / const
    t.y = self.y / const
    return t
end

function Vec2:__tostring()
    return "Vec2: x: " .. self.x .. " y: " .. self.y
end

function Vec2:rotate(angle)
    local t = Vec2:new()
    local rad = angle * math.pi / 180
    t.x = self.x * math.cos(rad) - self.y * math.sin(rad)
    t.y = self.x * math.sin(rad) + self.y * math.cos(rad)
    return t
end

function Vec2:getXY()
    return self.x, self.y
end

---@class Transform
---@field public class_name string
---@field public position Vec2
---@field public angle number
---@field public scale Vec2
Transform = { class_name = "Transform", position = nil, angle = 0, scale = nil }

function Transform:new(o)
    o = o or {}
    o.position = Vec2:new({ x = 0, y = 0 })
    o.scale = Vec2:new({ x = 1, y = 1 })
    setmetatable(o, self)
    self.__index = self
    return o
end

function Transform:getVectorRight()
    local t = Vec2:new({ x = 1, y = 0 })

    t = t:rotate(self.angle)
    return t:normalized()
end

function Transform:getVectorUp()
    local t = Vec2:new({ x = 0, y = -1 })

    t = t:rotate(self.angle)
    return t:normalized()
end

--@class Ease
Ease = {}

function Ease:linear(a, b, t)
    return Ease:custom(a, b, t, function(ta, tb, tt)
        return ta + (tb - ta) * tt
    end)
end

function Ease:inOutSine(a, b, t)
    return Ease:custom(a, b, t, function(ta, tb, tt)
        return ta + (tb - ta) * (-(math.cos(math.pi * tt) - 1) / 2)
    end)
end

function Ease:outSine(a, b, t)
    return Ease:custom(a, b, t, function(ta, tb, tt)
        return ta + (tb - ta) * (math.sin((tt * math.pi) / 2))
    end)
end

function Ease:inSine(a, b, t)
    return Ease:custom(a, b, t, function(ta, tb, tt)
        return ta + (tb - ta) * (1 - math.cos((tt * math.pi) / 2))
    end)
end

function Ease:custom(a, b, t, fun)
    if type(a) == "number" and type(b) == "number" then
        return fun(a, b, t)
    elseif type(a) == "table" and a.class_name == "Vec2" and type(b) == "table" and b.class_name == "Vec2" then
        local tmp = Vec2:new()
        tmp.x = fun(a.x, b.x, t)
        tmp.y = fun(a.y, b.y, t)
        return tmp
    else
        print("Ease: type not handled")
    end
end

---@class Color
---@field public class_name string
---@field public r number
---@field public g number
---@field public b number
---@field public a number
Color = { class_name = "Color", r = 0, g = 0, b = 0, a = 0 }

function Color:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Color:create(r, g, b, a)
    return Color:new({ r = r, g = g, b = b, a = a })
end

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

function table.contains(table, element)
    for key, value in pairs(table) do
        if value == element then
            return true, key
        end
    end
    return false, 0
end
