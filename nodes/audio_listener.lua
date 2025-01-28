require("Aether.nodes.node")

---The AudioSource node can be use to play audio
---@class AudioListener: Node
---@field public class_name string The Class name
---@field public source Vec2? The previous position
AudioListener = Node:new { class_name = "AudioListener", old_position = nil }

---Init AudioListener node
function AudioListener:init()
    love.audio.setOrientation(0, 1, 0, 0, 0, 1)
end

---Set the master audio's volume
---@param volume number
function AudioListener:setVolume(volume)
    love.audio.setVolume(volume)
end

---AudioListener's update
---@param dt number The delta time between two frame
function AudioListener:update(dt)
    local x, y = self:getGlobalPosition()
    love.audio.setPosition(x, y, 0)
    if self.old_position ~= nil then
        local ne = Vec2:create(x, y)
        local n = ne - self.old_position
        love.audio.getVelocity(n.x, n.y, 0)
    end

    self.old_position = Vec2:create(self:getGlobalPosition())
end

return AudioListener
