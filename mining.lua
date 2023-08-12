require ".utils"
require ".miningUtils"
require ".inventoryUtils"

print('starting', os.getComputerLabel(), 'for stripmining\n\nFace Turtle to north!\n')

--[[ try get current gps location -- {{ not working yet
if not getGPS() then
    print("unable connecting to GPS Server!")
    if choiceBool("give coordinates manually?") then
        y = choiceNumber("y coordinte", 0)
        -- y level
        yLevel = choiceNumber("mining Y level", y)
        downY = y - yLevel 
    else 
        -- y level
        yLevel = choiceNumber("mining level will be current minus given")
        downY = yLevel
        yLevel = "current minus " .. yLevel
    end
else
    y = getGPS()[1]
    -- y level
    yLevel = choiceNumber("mining Y level", y)
    downY = y - yLevel 
end
--]]

-- how many blocks the stripmine tunnel should be
depth = choiceNumber("mining depth", 40)

-- how many blocks the sub tunnels should be 
width = choiceNumber("mining width", 15)

-- wich direction to face north/east/south/west
direction = choice("direction(n/e/s/w)", {"n","e","s","w"})

-- will the mining shaft be 2 Blocks high?
shaftHight = choiceBool("shaft will be 2 Bloks high")

-- wether stones should be droped
dropStone = choiceBool("drop Stone?")

print("\nsettings:", 
    "\n  mining Y level:", yLevel,
    "\n  mining depth:", depth ,
    "\n  mining width:", width,
    "\n  direction:", direction,
    "\n  drop Stone: ", dropStone,
    "\n  shaft 2 blocks hight: ", shaftHight,
    "\n  turtle will go down:", downY
    )

textutils.slowWrite("continue?", 4)

if not choiceBool("") then
    do return end
end

---------------------------------------------------
--[[
    Ende des Prologs 
]]

print("\n------\nTurtle will face to given direction and move 2 Blocks forward.\nAfter that the turtle starts going to y Level and starts mining\n------")

refuel()
if dropStone then
    dropStonef()
end

-- fuelLevelSTR = tostring(turtle.getFuelLevel())
-- if choiceBool(tostring(turtle.getFuelLevel()))

setup(direction, downY)
stripMine(depth, width, dropStone, shaftHight)
dropToChest()
print("done!")
