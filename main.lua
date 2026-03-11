local sti = require "libs.sti"
local DEBUG = false

function love.load()
    Map = sti("assets/tilemaps/plains.lua")

    Path = {}
    Spawn = {}

    Enemies = {}
    Towers = {}

    Health = 100

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

        if enemy.health <= 0 then
            table.remove(Enemies, i)

        else
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
                Health = Health - enemy.damage
                table.remove(Enemies, i)
            end
        end
    end

    for _, tower in ipairs(Towers) do
        tower.cooldown = tower.cooldown - dt
        if tower.cooldown <= 0 then
            for _, enemy in ipairs(Enemies) do
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

    for _, enemy in ipairs(Enemies) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", enemy.x - enemy.width/2, enemy.y - enemy.height/2, enemy.width, enemy.height)

        local hpPercent = enemy.health / enemy.maxHealth

        love.graphics.setColor(0,1,0)
        love.graphics.rectangle("fill", enemy.x - 10, enemy.y - 12, 20 * hpPercent, 3)
        love.graphics.setColor(1,1,1)
    end

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
        local enemy = {
            x = Spawn.x,
            y = Spawn.y,
            target = 2,
            maxHealth = 20,
            health = 20,
            speed = 100,
            damage = 2,
            width = 8,
            height = 8
        }
        table.insert(Enemies, enemy)
    end

    if key == "f3" then
        DEBUG = not DEBUG
    end
end


function love.quit() end