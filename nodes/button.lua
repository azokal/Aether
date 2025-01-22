require("Aether.nodes.sprite")

---The Button node can be use to render button with the node system
---@class Button: Sprite
---@field public class_name string The Class name
---@field public interactable boolean Is the button interactable?
---@field public is_hover boolean Is the button hovered?
---@field public is_pressed boolean Is the button pressed?
---@field public visual_idle love.Image The LÖVE Image the button at idle state
---@field public visual_hover love.Image The LÖVE Image the button at hovered state
---@field public visual_exec love.Image The LÖVE Image the button at exec state
Button = Sprite:new { class_name = "Button", interactable = true, is_hover = false, is_pressed = false, visual_idle = nil, visual_hover = nil, visual_exec = nil }

---Init Button Node
---@param path_visual_idle string The idle visual's path
---@param path_visual_hover string? The hover visual's path
---@param path_visual_exec string? The exec visual's path
---@param mipmaps boolean? Use mimaps
---@param linear boolean? Use linear filter
function Button:init(path_visual_idle, path_visual_hover, path_visual_exec, mipmaps, linear)
    path_visual_hover = path_visual_hover or path_visual_idle
    path_visual_exec = path_visual_exec or path_visual_idle
    mipmaps = mipmaps or true
    linear = linear or true
    Sprite.init(self, path_visual_idle, mipmaps, linear)
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

---Placeholder for exec function
function Button:exec()
end

---Placeholder for hover function
---@param dt number The delta time between frame
function Button:hover(dt)
end

---Placeholder for when a cursor enter the button
function Button:onEnter()
end

---Placeholder for when a cursor exit the button
function Button:onExit()
end

---Update the button's node to add the logic
---@param dt number The delta time between frame
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
