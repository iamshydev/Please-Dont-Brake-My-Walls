local sti = require "libs.sti"
local DEBUG = true

function love.load()
    Map = sti("assets/tilemaps/plains.lua")

    Path = {}
    Spawn = {}
    Enemies = {}

    for _, layer in ipairs(Map.layers) do
        if layer.name == "EnemyPath" then
            local obj = layer.objects[1]
            Spawn = { x = layer.objects[2].x, y = layer.objects[2].y }
            
            for _, point in ipairs(obj.polyline) do
                table.insert(Path, { x = point.x, y = point.y })
            end
        end
    end
end

function love.update(dt) 
    for i = #Enemies, 1, -1 do
        local enemy = Enemies[i]
        local targetPoint = Path[enemy.target]

        if targetPoint then
            local dx = targetPoint.x - enemy.x
            local dy = targetPoint.y - enemy.y
            local dist = math.sqrt(dx*dx + dy*dy)

            if dist < 2 then
                enemy.target = enemy.target + 1
            else
                enemy.x = enemy.x + dx / dist * enemy.speed * dt
                enemy.y = enemy.y + dy / dist * enemy.speed * dt
            end
        else
            table.remove(Enemies, i)
        end
    end
end

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

    for _, enemy in ipairs(Enemies) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", enemy.x - enemy.width/2, enemy.y - enemy.height/2, enemy.width, enemy.height)
        love.graphics.setColor(1, 1, 1)
    end
end

function love.mousepressed(x, y, button, istouch) end

function love.keypressed(key) 
    if key == "return" then
        local enemy = {
            x = Spawn.x,
            y = Spawn.y,
            target = 2,
            speed = 100,
            width = 8,
            height = 8
        }
        table.insert(Enemies, enemy)
    end
end

function love.quit() end