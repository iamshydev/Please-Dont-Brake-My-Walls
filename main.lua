local sti = require "libs.sti"
require "src.EnemyManager"

local DEBUG = false

function love.load()
    Map = sti("assets/tilemaps/plains.lua")

    local path = {}
    Spawn = {}

    Health = 100

    for _, layer in ipairs(Map.layers) do
        if layer.name == "EnemyPath" then
            local obj = layer.objects[1]
            Spawn = { x = layer.objects[2].x, y = layer.objects[2].y }

            for _, point in ipairs(obj.polyline) do
                table.insert(path, { x = point.x, y = point.y })
            end
        end
    end

    EnemyManager = EnemyManager(path)
    Towers = {}
end

function love.update(dt)
    EnemyManager:update(dt)

    for _, tower in ipairs(Towers) do
        tower.cooldown = tower.cooldown - dt
        if tower.cooldown <= 0 then
            for _, enemy in ipairs(EnemyManager.enemies) do
                local dx = enemy.x - tower.x
                local dy = enemy.y - tower.y
                local dist = math.sqrt(dx*dx + dy*dy)

                if dist <= tower.range then
                    enemy.health = enemy.health - tower.damage
                    tower.cooldown = 1 / tower.fireRate
                    break
                end
            end
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

    EnemyManager:draw()

    for _, tower in ipairs(Towers) do
        love.graphics.setColor(1,1,0)
        love.graphics.rectangle("fill", tower.x - tower.width/2, tower.y - tower.height/2, tower.width, tower.height)

        if DEBUG then
            love.graphics.setColor(1,1,0,0.25)
            love.graphics.circle("line", tower.x, tower.y, tower.range)
        end

        love.graphics.setColor(1,1,1)
    end

    love.graphics.print(("Health: %d"):format(Health), 300, 20)
end


function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        local tower = {
            x = x,
            y = y,
            damage = 10,
            range = 36,
            fireRate = 1,
            cooldown = 0,
            width = 10,
            height = 10
        }
        table.insert(Towers, tower)
    end
end


function love.keypressed(key)
    if key == "return" then
        EnemyManager:spawnEnemy(Spawn.x, Spawn.y)
    end

    if key == "f3" then
        DEBUG = not DEBUG
    end
end


function love.quit() end