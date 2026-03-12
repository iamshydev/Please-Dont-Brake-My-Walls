function love.conf(t)
    t.identity = ".pdbmt"
    t.version = "11.5"

    t.window.title = "PDBMT"
    t.window.width = 480
    t.window.height = 320
    t.window.resizable = false
    t.window.highdpi = false
    t.window.vsync = 1

    t.modules.joystick = false
    t.modules.physics = false
    t.modules.video = false
end