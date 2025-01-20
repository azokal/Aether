require("sys.nodes.sprite")

---@class AnimatedSprite: Sprite
---@field public class_name string
---@field public column number
---@field public row number
---@field public max_frame number
---@field public current_frame number
---@field public is_playing boolean
---@field public time_between_frame number
---@field public current_timer number
AnimatedSprite = Sprite:new { class_name = "AnimatedSprite", column = 0, row = 0, max_frame = 0, current_frame = 0, is_playing = false, time_between_frame = 0, current_timer = 0 }

function AnimatedSprite:init(path, nb_column, nb_row, start_frame, max_frame, fps, play, mipmap, linear)
    Sprite.init(self, path, Vec2:create(0.5, 0.5), mipmap, linear)
    self.column = nb_column
    self.row = nb_row
    self.current_frame = start_frame - 1
    self.is_playing = play
    self.time_between_frame = 1 / fps
    self.max_frame = max_frame
    self:updateQuad()
end

function AnimatedSprite:play(from_start)
    if from_start == true then
        self.current_frame = 0
    end
    self.is_playing = true
end

function AnimatedSprite:pause()
    self.is_playing = false
end

function AnimatedSprite:stop()
    self.current_frame = 0
    self:pause()
end

function AnimatedSprite:updateQuad()
    local sw = self.asset:getWidth() / self.column
    local sh = self.asset:getHeight() / self.row
    self.quad:setViewport((self.current_frame % self.column) * sw, math.floor(self.current_frame / self.column) * sh,
        sw, sh, self.asset:getWidth(), self.asset:getHeight())
end

function AnimatedSprite:update(dt)
    if self.current_timer >= self.time_between_frame then
        self.current_timer = self.current_timer - self.time_between_frame
        self.current_frame = (self.current_frame + 1) % self.max_frame
        self:updateQuad()
    end
    self.current_timer = self.current_timer + dt
end
