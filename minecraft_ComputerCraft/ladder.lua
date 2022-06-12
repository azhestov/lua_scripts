--ladder dig down
--slot 1 - placeholder items
--slot 16 - fuelItems

local lv = 0
local stoneSlot = 1
local depth
local lastEmptySlot
local currentlySelectedSlot = 0
local currX
local currY
local currZ
local currOrient
local lastOrient
local startHeight 
local resumingFlag = false
local emergencyFuelToReturn = 4
local fuelLevelToRefuelAt = 30
local refuelItemsToUseWhenRefuelling = 1
local returningToStart = false
dir = { FORWARD=1, RIGHT=2, BACK=3, LEFT=4 }
----------
-----dig
-----------
function level()
ensureFuel()
  if turtle.detectDown() then
    turtle.digDown() 
  end
  while not turtle.down()
    turtle.attackDown()
  end
  currY = currY - 1
  lv = lv + 1
checkDown()
checkWall()
blockForward(0,1,0)
blockForward(0,1,0)
blockForward(0,1,0)
blockForward(0,1,1)
ensureFuel()
turtleSetOrientation(dir.RIGHT)
--row 2
blockForward(0,1,1)
turtleSetOrientation(dir.BACK)
blockForward(0,0,0)
blockForward(0,0,0)
blockForward(0,0,0)
blockForward(1,0,0)
ensureFuel()
turtleSetOrientation(dir.LEFT)
--row 3
blockForward(1,0,0)
turtleSetOrientation(dir.FORWARD)
blockForward(0,0,0)
blockForward(0,0,0)
blockForward(0,0,0)
blockForward(0,0,1)
ensureFuel()
turtleSetOrientation(dir.RIGHT)
--row 4
blockForward(0,1,1)
turtleSetOrientation(dir.BACK)
blockForward(0,1,0)
if lv == 4 then
--torch
  turtle.turnLeft()
  turtle.select(2)
  currentlySelectedSlot = 2
  turtle.place()
  turtle.turnRight()
  lv = 0
--
end
blockForward(0,1,0)
blockForward(0,1,0)
blockForward(0,1,1)
ensureFuel()
--back
turtle.back()
turtleSetOrientation(dir.LEFT)
turtleForward(3)
turtleSetOrientation(dir.FORWARD)

end


function blockForward(down,left,up)
  if turtle.detect() then
  checkSpace()
    turtle.dig()
  end

  while not turtle.forward() then
    turtle.attack()
  end
  
  if currOrient == dir.FORWARD then currX = currX + 1 end
  if currOrient == dir.BACK then currX = currX - 1 end
  if currOrient == dir.RIGHT then currZ = currZ + 1 end
  if currOrient == dir.LEFT then currZ = currZ - 1 end
  
  if down == 1 then 
  checkDown()
  end
  if left == 1 then
  checkWall()
  end
  if up == 1 then
  checkUp()
  end
end

----------
---- move
----------

function turtleUp(times)
  for i=1,times do
  ensureFuel()
    turtle.up()
  end
end


function turtleDown(times)
  for i=1,times do
  ensureFuel()
    turtle.down()
  end
end


function turtleForward(times)
  for i=1,times do
  ensureFuel()
    turtle.forward()
  end
end


function turtleBack(times)
  for i=1,times do
  ensureFuel()
    turtle.back()
  end
end



function turtleSetOrientation(newOrient)
  if currOrient > newOrient then
    for i in 1, (currOrient - newOrient) do
    turtle.turnLeft()
    end
  elseif newOrient > currOrient
    for i in 1, (newOrient - currOrient) do
    turtle.turnRight()
    end
  end
end


function GoHome()
lastOrient = currOrient
turtleSetOrientation(dir.LEFT)
turtleForward(currZ)
turtleSetOrientation(dir.BACK)
while not turtle.detect() do
turtle.forward()
end
  depth = currY
  while depth < start_y do
  turtle.up()
  turtle.forward()
  depth = depth + 1
  end
  
--check chest here
  
  turtle.select(1)
  if turtle.getItemCount(1) > 1 then turtle.drop( turtle.getItemCount(1) -1)
  for i in 3, 15 do
  turtle.drop(turtle.getItemCount(i))
  end
--load stone here  

if turtle.getItemCount(1) < 10 then
turtle.select(1)
	while (turtle.getItemCount(1) < 64)
	do
  turtle.suck()
 end

end
  --refuel
  if (turtle.getItemCount(16) < 64) then
  turtleSetOrientation(dir.LEFT)
  turtle.select(16) -- Don't bother updating selected slot variable as it will set later in this function
  local currFuelItems = turtle.getItemCount(16)
  turtle.drop(currFuelItems)
  while (turtle.getItemCount(16) < 64) do
  turtle.suck()
  currFuelItems = turtle.getItemCount(16)
  end
  turtleSetOrientation(dir.FORWARD)
  if resumingFlag == true then
  resuming()
  end
  
end

function resuming()
turtleSetOrientation(dir.FORWARD)
	for i in 1, currX - start_x do
	turtle.forward()
	 if not turtle.detectDown() then
	turtle.down()
	end
	end
turtleSetOrientation(dir.RIGHT)
	for i in 1, currY do
	turtle.forward()
	turtleSetOrientation(lastOrient)
	end

end

---------
--check
---------


function isChestBlock(compareFn)
  local returnVal = false
  if (lookForChests == true) then
    turtle.select(15)
    currentlySelectedSlot = 15
    returnVal = compareFn()
  end
  return returnVal
end

function ensureFuel()
  local fuelLevel = turtle.getFuelLevel()
  if (fuelLevel ~= "unlimited") then
    if (fuelLevel < fuelLevelToRefuelAt) then
      turtle.select(16)
      currentlySelectedSlot = 16
      local fuelItems = turtle.getItemCount(16)
        if (fuelItems < emergencyFuelToReturn + refuelItemsToUseWhenRefuelling) then
        returningToStart = true
        end
      turtle.refuel(refuelItemsToUseWhenRefuelling)
    end
  end
  if returningToStart == true then GoHome end
end        

function checkSpace()
local counter
	for i in 1, 15 do
	 counter = turtle.getItemCount(i)
	 if counter == 0 then 
	 lastEmptySlot = i
	 return 0
	 end
	 tutrtle.select(i)
	 if turtle.compare() and counter < 64 then
	 return 0
	 
	 
resumingFlag = true
GoHome()
return 1
--suuuucs!
end





function checkDown()
  if not turtle.detectDown() then
    checkStone()
    turtle.select(stoneSlot)
    currentlySelectedSlot = stoneSlot
    while not turtle.placeDown() do 
      turtle.attackDown()
    end
  end
end

function checkWall()
turtle.turnLeft()
  if not turtle.detect() then
  checkStone()
  turtle.select(stoneSlot)
  currentlySelectedSlot = stoneSlot
    while not turtle.place() do 
    turtle.attack()
    end
  end
turtle.turnRight()
end

function checkUp()
  if not turtle.detectUp() then
  checkStone()
  turtle.select(stoneSlot)
  currentlySelectedSlot = stoneSlot
    while not turtle.placeUp() do 
    turtle.attack()
    end
  end
end

function checkStone()
  if turtle.getItemCount(stoneSlot) = 1 then
  turtle.select(stoneSlot)
    for i in 15, 1, -1 do
     if turtle.getItemCount(stoneSlot) < 64 then
      if turtle.compareTo(i) then 
        turtle.select(i)
        if turtle.getItemCount(i) = 64 then
	turtle.transferTo(1, 64 - turtle.getItemCount(stoneSlot))
	else
	turtle.transferTo(1,turtle.getItemCount(i))
	end      
      end
     end
    end
    if turtle.getItemCount(stoneSlot) = 1 then 
    GoHome 
    end
  end
end


----



-------------------------------MAIN
local args = { ... }
local paramsOK = true
-------paramsOK
if (#args == 1) then
  startHeight =  = tonumber(args[1])
  
else
  print("need startHeight!")
  running = false
end

----save start place
currX = 0
currY = startHeight
currZ = 0
currOrient = dir.FORWARD

start_x = currX
start_y = currY
start_z = currZ
startOrient = currOrient

turtle.select(1)
currentlySelectedSlot = 1
turtle.forward()
for i in 1, startHeight - 10
level()
end