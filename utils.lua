---Vector2 Class
---@class Vec2
---@field public class_name string The Class name
---@field public x number The x value
---@field public y number The y value
Vec2 = { class_name = "Vec2", x = 0, y = 0 }

---Vec2 constructor
---@param o table? Table model used for the copy
---@return Vec2 v The Vec2 instance
function Vec2:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Create new Vec2 from x and y
---@param x number The x value
---@param y number The y value
---@return Vec2 v The Vec2 instance
function Vec2:create(x, y)
    return Vec2:new({ x = x, y = y })
end

---Get the magnitude of the Vec2
---@return number d Vec2's magnitude
function Vec2:magnitude()
    return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
end

---Normalize the Vec2
---@return Vec2 v Normalized Vec2
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

---Add operator overload
---@param right table|number Value to add
---@return Vec2 v Vec2 with the new value
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

---Subtract operator overload
---@param right table|number Value to subtract
---@return Vec2 v Vec2 with the new value
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

---Multiply operator overload
---@param const number Value to multiple
---@return Vec2 v Vec2 with the new value
function Vec2:__mul(const)
    local t = Vec2:new()
    t.x = self.x * const
    t.y = self.y * const
    return t
end

---Divide operator overload
---@param const number Value to divide
---@return Vec2 v Vec2 with the new value
function Vec2:__div(const)
    local t = Vec2:new()
    t.x = self.x / const
    t.y = self.y / const
    return t
end

---To string function
---@return string str The Vec2 value as string
function Vec2:__tostring()
    return "Vec2: x: " .. self.x .. " y: " .. self.y
end

---Rotate the Vec2
---@param angle number The angle for the rotation
---@return Vec2 v Vec2 with the new value
function Vec2:rotate(angle)
    local t = Vec2:new()
    local rad = angle * math.pi / 180
    t.x = self.x * math.cos(rad) - self.y * math.sin(rad)
    t.y = self.x * math.sin(rad) + self.y * math.cos(rad)
    return t
end

---Decompose the Vec2's values
---@return number x The x value
---@return number y The y value
function Vec2:getXY()
    return self.x, self.y
end

---The Transform for the node that store the position, rotation and scale
---@class Transform
---@field public class_name string The Class name
---@field public position Vec2? The position
---@field public angle number The rotation
---@field public scale Vec2? The scale
Transform = { class_name = "Transform", position = nil, angle = 0, scale = nil }

---Transform constructor
---@param o table? Table model used for the copy
---@return Transform v Transform instance
function Transform:new(o)
    o = o or {}
    o.position = Vec2:new({ x = 0, y = 0 })
    o.scale = Vec2:new({ x = 1, y = 1 })
    setmetatable(o, self)
    self.__index = self
    return o
end

---Get the right Vec2 from the Transform data
---@return Vec2 v Rigth normalize Vec2
function Transform:getVectorRight()
    local t = Vec2:new({ x = 1, y = 0 })

    t = t:rotate(self.angle)
    return t:normalized()
end

---Get the up Vec2 from the Transform data
---@return Vec2 v Up normalize Vec2
function Transform:getVectorUp()
    local t = Vec2:new({ x = 0, y = -1 })

    t = t:rotate(self.angle)
    return t:normalized()
end

-- --@class Ease
-- Ease = {}

-- function Ease:linear(a, b, t)
--     return Ease:custom(a, b, t, function(ta, tb, tt)
--         return ta + (tb - ta) * tt
--     end)
-- end

-- function Ease:inOutSine(a, b, t)
--     return Ease:custom(a, b, t, function(ta, tb, tt)
--         return ta + (tb - ta) * (-(math.cos(math.pi * tt) - 1) / 2)
--     end)
-- end

-- function Ease:outSine(a, b, t)
--     return Ease:custom(a, b, t, function(ta, tb, tt)
--         return ta + (tb - ta) * (math.sin((tt * math.pi) / 2))
--     end)
-- end

-- function Ease:inSine(a, b, t)
--     return Ease:custom(a, b, t, function(ta, tb, tt)
--         return ta + (tb - ta) * (1 - math.cos((tt * math.pi) / 2))
--     end)
-- end

-- function Ease:custom(a, b, t, fun)
--     if type(a) == "number" and type(b) == "number" then
--         return fun(a, b, t)
--     elseif type(a) == "table" and a.class_name == "Vec2" and type(b) == "table" and b.class_name == "Vec2" then
--         local tmp = Vec2:new()
--         tmp.x = fun(a.x, b.x, t)
--         tmp.y = fun(a.y, b.y, t)
--         return tmp
--     else
--         print("Ease: type not handled")
--     end
-- end

---Color Class
---@class Color
---@field public class_name string The Class name
---@field public r number Red component
---@field public g number Green component
---@field public b number Blue component
---@field public a number Alpha component
Color = { class_name = "Color", r = 0, g = 0, b = 0, a = 0 }

---Color constructor
---@param o table? Table model used for the copy
---@return Color color Color instance
function Color:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Create new Color from r, g, b a
---@param r number Red component
---@param g number Green component
---@param b number Blue component
---@param a number Alpha component
---@return Color color The Color instance
function Color:create(r, g, b, a)
    return Color:new({ r = r, g = g, b = b, a = a })
end

---Split string by a sparator
---@param sep string Separator
---@return string[] splited_str The Splited string
function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

---Check if a table contains a element
---@param element any What to find
---@return boolean Is found
---@return any key Found key's value
function table:contains(element)
    for key, value in pairs(self) do
        if value == element then
            return true, key
        end
    end
    return false, 0
end
