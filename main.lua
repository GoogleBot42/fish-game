local i,v
local j,k

local speed = 300
local food = {}
local shark = {}
local player = {
  x = 300,
  y = 300,
  r = 30,
  flip = false
}
local img = {}

local score = 0
local lives = 3

function love.load()
  math.randomseed(os.time())
  love.mouse.setVisible(false)
  addFood()
  addShark()
  img.fish = love.graphics.newImage("fish_swim.png")
  img.food = love.graphics.newImage("food.png")
  img.grass = love.graphics.newImage("grass.png")
  img.background = love.graphics.newImage("background.png")
  img.shark = love.graphics.newImage("shark.png")
end

function love.update(dt)
  for i,v in ipairs(food) do
    v.x = v.x + dt*v.dx
    v.y = v.y + dt*v.dy
    if v.x < -30 then
      v.x = 830
    elseif v.y < -30 then
      v.y = 630
    elseif v.x > 830 then
      v.x = -30
    elseif v.y > 630 then
      v.y = -30
    end
  end
  for i,v in ipairs(shark) do
    v.x = v.x + dt*v.dx
    v.y = v.y + dt*v.dy
    if v.x < -50 then
      v.x = 850
    elseif v.y < -50 then
      v.y = 650
    elseif v.x > 850 then
      v.x = -50
    elseif v.y > 650 then
      v.y = -50
    end
  end

  toRemove = {}
  for j,k in ipairs(shark) do
    if collide(player,k) then
      table.insert(toRemove,j)
    end
  end
  if #toRemove ~= 0 then
    player.x = 300
    player.y = 300
  end
  lives = lives - #toRemove
  for i,v in ipairs(toRemove) do
    table.remove(shark, v)
  end
  for i,v in ipairs(toRemove) do
    addShark()
    addShark()
  end

  -- check to see if player ate food
  toRemove = {}
  for j,k in ipairs(food) do
    if collide(player,k) then
      table.insert(toRemove,j)
      if lives > 0 then
        score = score + 1
        addShark()
      end
    end
  end
  for i,v in ipairs(toRemove) do
    table.remove(food, v)
  end
  for i,v in ipairs(toRemove) do
    addFood()
  end

  -- TODO: make this logic better
  if math.floor(score) ~= math.floor(score + dt) then
    if math.random(0,4) == 0 then
      addFood()
    end
    if math.floor(score + dt) % 10 == 0 then
      addShark()
    end
    if score % 2 == 0 then
      addShark()
    end
  end

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

  if love.keyboard.isDown("left") then
    player.x = player.x - dt * speed 
    player.flip = false
  end
  if love.keyboard.isDown("right") then
    player.x = player.x + dt * speed 
    player.flip = true
  end
  if love.keyboard.isDown("up") then
    player.y = player.y - dt * speed 
  end
  if love.keyboard.isDown("down") then
    player.y = player.y + dt * speed 
  end
end

function love.draw()

  love.graphics.draw(img.background, 0, 0)

  for i,v in ipairs(food) do
    -- love.graphics.circle("fill", v.x, v.y, v.r)
    love.graphics.draw(img.food, v.x - 30, v.y - 30, 0, 0.3)
  end

  for i,v in ipairs(shark) do
    -- love.graphics.circle("fill", v.x, v.y, v.r)
    love.graphics.draw(img.shark, v.x - 70, v.y - 60, 0, 0.25, 0.25)
  end

  -- love.graphics.circle("fill", player.x, player.y, player.r)
  local flip = 1
  local pos = 0
  if player.flip then
    flip = -1
    pos = 100
  end
  love.graphics.draw(img.fish, pos + player.x - 50, player.y - 30, 0, flip * 0.2, 0.2)

  love.graphics.print('Score: ' .. math.floor(score), 10, 0, 0, 3)
  love.graphics.print('Lives: ' .. lives, 10, 35, 0, 3)


  if lives <= 0 then
    love.graphics.print('GAME OVER', 0, 0, 0, 10)
  end
end

function addFood()
  table.insert(food, {
    x = 830, y=math.random(100, 500), r=math.random(10,20),
    dx=-math.random(30,50), dy=math.random(30,50)
  })
end

function addShark()
  table.insert(shark, {
    x = 850, y=math.random(0, 600), r=math.random(40,50),
    dx=3*math.random(-30,-50), dy=(math.random(0,2)-1)*math.random(-30,-50)
  })
end

function collide(a, b)
  local x = a.x - b.x
  local y = a.y - b.y
  local r = a.r + b.r
  return x*x + y*y <= r*r
end