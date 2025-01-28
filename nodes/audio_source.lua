Aether = Aether or require("Aether.Aether")
require("Aether.nodes.node")

---The AudioSource node can be use to play audio
---@class AudioSource: Node
---@field public class_name string The Class name
---@field public source love.Source? The LÖVE audio source
AudioSource = Node:new { class_name = "AudioSource", source = nil }

---Init AudioSource node
---@param path string The audio's path
---@param loop boolean? Do the audio loop?
---@param playOnInit boolean? Play on init
---@param setting love.SourceType? The LÖVE SourceType
function AudioSource:init(path, loop, playOnInit, setting)
    setting = setting or "static"
    playOnInit = playOnInit or true
    loop = loop or false
    self.source = Aether.resource:loadAudio(path, setting)

    if playOnInit then
        self.source:play()
    end
    self.source:setLooping(loop)
end

---Play the audioSource
function AudioSource:play()
    self.source:play()
end

---Change the play position
---@param position number The new position
---@param type love.TimeUnit The LÖVE TimeUnit for the position
function AudioSource:seek(position, type)
    self.source:seek(position, type)
end

---Stop the audio source
function AudioSource:stop()
    self.source:stop()
end

---Pause the audio source
function AudioSource:pause()
    self.source:pause()
end

---Set the audio source's volume
---@param volume number
function AudioSource:setVolume(volume)
    self.source:setVolume(volume)
end

---AudioSource's update
---@param dt number The delta time between two frame
function AudioSource:update(dt)
    if self.source:getChannelCount() == 1 then
        self.source:setPosition(self:getGlobalPosition(), 0);
    end
end

return AudioSource
