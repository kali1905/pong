push = require 'push'

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 648
VIRTUAL_HEIGHT = 364

PADDLE_SPEED = 450

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    math.randomseed(os.time())
    
    smallFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 52)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    
    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 100

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)
    
    gameState = 'start'
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y +  -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 50, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y +  -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 50, player2Y + PADDLE_SPEED * dt)  
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

function love.keypressed(key)
    if key == 'escape' then
         love.event.quit()
         gameState = 'start'
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else 
            gameState = 'start'
            
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end
    end

end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setFont(smallFont)
    
    if gameState == 'start' then
        love.graphics.printf('Aşkımla pong oynicazzz!!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Aşkımla pong oynuyoruzzz!!', 0, 20, VIRTUAL_WIDTH, 'center')
    end
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT /4)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT /4)
    
    love.graphics.rectangle('fill', 10, player1Y, 5, 50)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 50)    
    love.graphics.rectangle('fill', ballX, ballY, 5, 5)
    
    push:apply('end')
end

