local sti = require "libs.sti"
require "src.EnemyManager"
require "src.TowerManager"

DEBUG = false

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
    TowerManager = TowerManager()
end

function love.update(dt)
    EnemyManager:update(dt)
    TowerManager:update(dt)
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
    TowerManager:draw()

    love.graphics.print(("Health: %d"):format(Health), 300, 20)
end


function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        TowerManager:spawnTower(x, y)
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