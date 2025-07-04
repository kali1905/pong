push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'


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
    largeFont = love.graphics.newFont('font.ttf', 32)
    scoreFont = love.graphics.newFont('font.ttf', 24)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
        canvas = false
    })
    
    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 50)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 100, 5, 50)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    servingPlayer = 1

    winningPlayer = 0

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-150, 150)
        if servingPlayer == 1 then
            ball.dx = -math.random(300, 400)
        else
            ball.dx = math.random(300, 400)
        end
    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.08
            ball.x = player1.x + 5
            
            if ball.dy < 0 then
                ball.dy = -math.random(50, 200)
            else
                ball.dy = math.random(50, 200)
            end

            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.08
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(50, 200)
            else
                ball.dy = math.random(50, 200)
            end

            sounds['paddle_hit']:play()

        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT -4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()
            
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
    end
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()
            
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            ball:reset()
            
            player1Score = 0
            player2Score = 0
            
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end

end

function love.draw()
    push:start()
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    if gameState == 'start' then
        
        love.graphics.setFont(smallFont)
        love.graphics.printf('Hoşgeldin aşkım', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Başlamak için entera bas', 0, 40, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        
        love.graphics.setFont(smallFont)
        love.graphics.printf('Oyuncu'.. tostring(servingPlayer) .. "oyna!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Entere bas', 0, 40, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        
    elseif gameState == 'done' then
        
        love.graphics.setFont(largeFont)
        love.graphics.printf('Oyuncu ' .. tostring(winningPlayer) .. ' kazandı!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Geri başlamak için entere bas', 0, 100, VIRTUAL_WIDTH, 'center')
    end
    displayScore()
    player1:render()
    player2:render()
    ball:render()
    displayFPS()
    push:finish()
end

function displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end
