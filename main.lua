push = require 'push'

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 648
VIRTUAL_HEIGHT = 364

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.draw()
    
    
end

function love.draw()
    love.graphics.printf(
          'Hello Pong!',
          0,
          WINDOW_HEIGHT / 2 - 6,
          WINDOW_WIDTH,
          'center')    
end