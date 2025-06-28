push = require 'push'
Class = require 'class'
require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 648
VIRTUAL_HEIGHT = 364

PADDLE_SPEED = 450

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    math.randomseed(os.time())
    
    smallFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 24)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    
    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 50)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 100, 5, 50)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    gameState = 'start'
end

function love.update(dt)
    if gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + player1.width
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - ball.width
        end

        if ball.x < 0 then
            player2Score = player2Score + 1
            gameState = 'start'
            ball:reset()
        elseif ball.x > VIRTUAL_WIDTH then
            player1Score = player1Score + 1
            gameState = 'start'
            ball:reset()
        end

        if ball.y <= 0 or ball.y >= VIRTUAL_HEIGHT - ball.height then
            ball.dy = -ball.dy
        end
    end

    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else 
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else 
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end
    
    player1:update(dt)
    player2:update(dt)

end

function love.keypressed(key)
    if key == 'escape' then
         love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else 
            gameState = 'start'
            
            ball:reset()
        end
    end

end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setFont(smallFont)
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)

    if gameState == 'start' then
        love.graphics.printf('Pongu başlat(Enter)', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Pong başladı', 0, 20, VIRTUAL_WIDTH, 'center')
    end
    
    player1:render()
    player2:render()
    ball:render()
    displayFPS()
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
