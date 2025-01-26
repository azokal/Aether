require("Aether.nodes.sprite")

---The AnimatedSprite node can be use to render a Animation from the a spritesheet with the node system
---@class AnimatedSprite: Sprite
---@field public class_name string The Class name
---@field public column number The number of column in the spritesheet
---@field public row number The number of row in the spritesheet
---@field public max_frame number The number of frame in the animation
---@field public current_frame number The number of the current frame
---@field public is_playing boolean Is playing?
---@field public time_between_frame number The time to wait before change frame
---@field public current_timer number The current timer to track when change frame
AnimatedSprite = Sprite:new { class_name = "AnimatedSprite", column = 0, row = 0, max_frame = 0, current_frame = 0, is_playing = false, time_between_frame = 0, current_timer = 0 }

---Init AnimatedSprite node
---@param path string The Spritesheet's path
---@param nb_column number The number of column in the spritesheet
---@param nb_row number The number of row in the spritesheet
---@param start_frame number The start frame
---@param max_frame number The number of frame in the animation
---@param fps number The number frame by seconde used in the animation
---@param play boolean Start the animation on init
---@param mipmaps boolean Use mimaps
---@param linear boolean Use linear filter
function AnimatedSprite:init(path, nb_column, nb_row, start_frame, max_frame, fps, play, mipmaps, linear)
    mipmaps = mipmaps or true
    linear = linear or true
    Sprite.init(self, path, mipmaps, linear)
    self.column = nb_column
    self.row = nb_row
    self.current_frame = start_frame - 1
    self.is_playing = play
    self.time_between_frame = 1 / fps
    self.max_frame = max_frame
    self:updateQuad()
end

---Play/Resume the animation
---@param from_start boolean From start?
function AnimatedSprite:play(from_start)
    if from_start == true then
        self.current_frame = 0
    end
    self.is_playing = true
end

---Pause the animation
function AnimatedSprite:pause()
    self.is_playing = false
end

---Stop the animation
function AnimatedSprite:stop()
    self.current_frame = 0
    self:pause()
end

---Update the LÖVE Quad used in sprite with the animation information
function AnimatedSprite:updateQuad()
    local sw = self.asset:getWidth() / self.column
    local sh = self.asset:getHeight() / self.row
    self.quad:setViewport((self.current_frame % self.column) * sw, math.floor(self.current_frame / self.column) * sh,
        sw, sh, self.asset:getWidth(), self.asset:getHeight())
end

---Update the AnimatedSprite node
---@param dt number The delta time between frame
function AnimatedSprite:update(dt)
    if self.current_timer >= self.time_between_frame then
        self.current_timer = self.current_timer - self.time_between_frame
        self.current_frame = (self.current_frame + 1) % self.max_frame
        self:updateQuad()
    end
    self.current_timer = self.current_timer + dt
end

return AnimatedSprite
