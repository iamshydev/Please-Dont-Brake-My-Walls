local sti = require "libs.sti"
local DEBUG = true

function love.load()
    Map = sti("assets/tilemaps/plains.lua")
end

function love.update() end

function love.draw() 
    if DEBUG then
        Map:draw()
    else 
        for _, layer in ipairs(Map.layers) do
            if layer.type == "tilelayer" then
                layer:draw()
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch) end

function love.keypressed(key) end

function love.quit() end