require("Aether.nodes.animated_sprite")

Animation = AnimatedSprite:new { class_name = "Animation", animation_data = nil, current = "", speed = 1 }

function Animation:init(data)
    self.animation_data = {}
    for i = 1, #data, 1 do
        self.animation_data[data[i].name] = data[i]
    end
end

function Animation:start_animation(name, speed)
    self.speed = speed
    self.current = name
    AnimatedSprite.init(self, self.animation_data[self.current].path, self.animation_data[self.current].column,
        self.animation_data[self.current].row,
        self.animation_data[self.current].start_frame, self.animation_data[self.current].max_frame,
        self.animation_data[self.current].fps, false,
        false, false)
    self.pivot.x = self.animation_data[self.current].pivot.x
    self.pivot.y = self.animation_data[self.current].pivot.y
    self:play(true)
end

function Animation:change_animation(name)
    self:start_animation(name, self.speed)
end

function Animation:update(dt)
    local current_frame = self.current_frame
    AnimatedSprite.update(self, dt * self.speed)
    if current_frame ~= self.current_frame then
        for i = 1, #(self.animation_data[self.current].events), 1 do
            if self.animation_data[self.current].events[i].frame - 1 == self.current_frame then
                self[self.animation_data[self.current].events[i].func](self,
                    self.animation_data[self.current].events[i].arg)
            end
        end
    end
end

return Animation
