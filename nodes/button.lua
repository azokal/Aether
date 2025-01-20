require("Aether.nodes.sprite")

---@class Button: Sprite
---@field public class_name string
---@field public interactable boolean
---@field public is_hover boolean
---@field public is_pressed boolean
---@field public visual_idle love.Image
---@field public visual_hover love.Image
---@field public visual_exec love.Image
Button = Sprite:new { class_name = "Button", interactable = true, is_hover = false, is_pressed = false, visual_idle = nil, visual_hover = nil, visual_exec = nil }

function Button:init(path_visual_idle, path_visual_hover, path_visual_exec, mipmaps, linear)
    Sprite.init(self, path_visual_idle, Vec2:create(0.5, 0.5), mipmaps, linear)
    self.visual_idle = self.asset

    if path_visual_hover == nil then
        self.visual_hover = self.visual_idle
    else
        self.visual_hover = self.app.resource:loadImage(path_visual_hover, { mipmaps = mipmaps, linear = linear })
    end
    if path_visual_exec == nil then
        self.visual_exec = self.visual_idle
    else
        self.visual_exec = self.app.resource:loadImage(path_visual_exec, { mipmaps = mipmaps, linear = linear })
    end
end

function Button:exec()
end

function Button:hover(dt)
end

function Button:onEnter()
end

function Button:onExit()
end

function Button:update(dt)
    local mx, my = self.app.input.mouse:getPosition()
    local gposx, gposy = self:getGlobalPosition()
    local cameras = self.app.scene_manager:getCurrentScene():findNodesOfType("Camera")
    if #cameras > 0 then
        local wpos = Vec2:create(mx, my)
        if self.layer ~= Layer.UI then
            wpos = cameras[1]:convertScreenToWorld(wpos)
        else
            local r = cameras[1]:getRatioGameScreen()
            wpos = wpos / r
        end
        local _, _, w, h = self.quad:getViewport()
        if wpos.x >= gposx - w * self.pivot.x and wpos.x <= gposx + w * (1 - self.pivot.x)
            and wpos.y >= gposy - h * self.pivot.y and wpos.y <= gposy + h * (1 - self.pivot.y) then
            if self.is_hover == false then
                self:onEnter()
            end
            self.is_hover = true;
        else
            if self.is_hover then
                self:onExit()
            end
            self.is_hover = false;
        end
        if self.is_hover == true then
            self.asset = self.visual_hover
            self:hover(dt)
        else
            self.asset = self.visual_idle
        end
        if self.app.input:isDown("mouse1") and self.is_hover then --TODO change to dont use directly love
            self.asset = self.visual_exec
            self.is_pressed = true
        elseif self.is_pressed and self.is_hover then
            self.is_pressed = false
            self:exec()
        end
        --self.asset = self.visual_idle
        --print("mx: " .. mx .. " my: " .. my .. " gposx: " .. gposx .. " gposy: " .. gposy)
        --print("wposx: " .. wpos.x .. " wposy: " .. wpos.y .. " w: " .. w .. " h: " .. h)
    else
        print("No Camera fond for UI")
    end
end
