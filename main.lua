push = require 'push'

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 648
VIRTUAL_HEIGHT = 364

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    smallFont = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    if key == 'escape' then
         love.event.quit()
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
        
    love.graphics.rectangle('fill', 10, 30, 5, 50)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 100, 5, 50)    
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 5, VIRTUAL_HEIGHT / 2 - 25, 5, 5)
    
    
    push:apply('end')
end

