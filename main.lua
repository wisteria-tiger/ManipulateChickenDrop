if arg[2] == "debug" then
    require("lldebugger").start()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

--game where animals fall from top player clicks
--before hit the bottom
--game ends when animal hits bottom

function love.load()
    gem = love.graphics.newImage("assets/gemBlue.png")
    powerUpHammer = love.graphics.newImage("assets/hammer.png")
    backgroundImage = love.graphics.newImage("assets/background.png")
    

    math.randomseed(os.time())
    math.random(); math.random(); math.random()
    startx = {math.random(0, love.graphics.getWidth() - gem:getWidth()),
                math.random(0, love.graphics.getWidth() - gem:getWidth()),
                math.random(0, love.graphics.getWidth() - gem:getWidth()),
                math.random(0, love.graphics.getWidth() - gem:getWidth()),
                math.random(0, love.graphics.getWidth() - gem:getWidth())}

    starty = {0 - math.random(gem:getHeight(), gem:getHeight() * 2),
                0 - math.random(gem:getHeight(), gem:getHeight() * 2),
                0 - math.random(gem:getHeight(), gem:getHeight() * 2),
                0 - math.random(gem:getHeight(), gem:getHeight() * 2),
                0 - math.random(gem:getHeight(), gem:getHeight() * 2)}

    hammerX = math.random(0, love.graphics.getWidth() - powerUpHammer:getWidth())
    hammerY = math.random(0, love.graphics.getHeight() - powerUpHammer:getHeight())
    powerFlag = false;
end
-------------------------------------------------
--MOUSE PRESS
--1 = left, 2 = right, 3 = middle wheel
-------------------------------------------------
function love.mousepressed(x, y, button, istouch)
    if button == 1 then
    --print("left mouse clicked")
        for i, v in ipairs(startx) do
        --if the mouse x and y is within the boundary of a chicken picture
            if x >= startx[i] and x <= startx[i] + gem:getWidth() and y >=
starty[i] and y <= starty[i] + gem:getHeight() then
                --print("in bounds")
                math.randomseed(os.time())
                math.random(); math.random(); math.random()
                --reset its y value (go back to the top)
                starty[i] = math.random(gem:getHeight(), gem:getHeight() *
                2) * -1
            end
        end
            if x >= hammerX and x <= hammerX + powerUpHammer:getWidth() and y >=
hammerY and y <= hammerY + powerUpHammer:getHeight() then
                --Spawns hammer power up at random position
                math.randomseed(os.time())
                math.random(); math.random(); math.random()
                hammerX = (0 - powerUpHammer:getWidth())
                hammerY = (0 - powerUpHammer:getHeight())
                --Activates power up effect
                powerFlag = true
            end
    end
end

--Manages power up effect
function updateGemSpeed(dt)
    if powerFlag == true then
        for i, v in ipairs(starty) do
        starty[i] = starty[i] + 40 * dt
        end
    end
end
-------------------------------------------------
--UPDATE
-------------------------------------------------
function love.update(dt)
    for i, v in ipairs(starty) do
        --if chicken hits the bottom of the screen, lua quits (we lose)
        if starty[i] + gem:getHeight() >= love.graphics.getHeight() then
        --print("over the edge")
            love.event.quit()
        end
        --chickens move down
        starty[i] = starty[i] + 80 * dt
        updateGemSpeed(dt)
    end
end
-------------------------------------------------
--DRAW
-------------------------------------------------
function love.draw()
    love.graphics.draw(backgroundImage, 0, 0)
    --draw each chicken at their respective x and y
    for i, v in ipairs(startx) do
        love.graphics.draw(gem, startx[i], starty[i])
    end
    love.graphics.draw(powerUpHammer, hammerX, hammerY)
end
