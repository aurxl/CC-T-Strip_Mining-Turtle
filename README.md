# CC-T-Strip_Mining-Turtle
type: quick shot

## Description
Most of the code was written in one night around 3 a.m. with the power of a lot of Club Mate. So dont expect clean, efficient and readable code.

This lua script was written for [CC:Tweaked](https://www.modrinth.com/mod/cc-tweaked) it may also work for other CC Mods.

With this lua script, the turtle will mine ressources at any level with the good old strip mining technique.
Btw. the turtle works best with a chunk loader. (Fabric mod: [Turtlematic](https://modrinth.com/mod/turtlematic) / Forge mod: [Advanced Peripherals](https://modrinth.com/mod/advancedperipherals))

## Features
- strip mining
- turtle follows ore veins to make sure to get all of the important ressources
- configure Length of main and sub shaft
- place torches
- place chests
- dropping not wanted stones
- setup chunk loader (mod required)

## Usage
- copy repo to turtle
- [configure](#configuration) available options in config.lua file
- place turtle at favorite hight
- start mining by typing `mining`

## Configuration
- make config changes by editing config.lua
  - `edit config.lua`
- By running `setup_chunk_loader.lua` and placing the chunkloader at the first itemslot, the chunkloader will be equiped.

sample config.lua:
``` lua
-- coal can be given to any slot
--[[
    if torches should be placed
    and which slot to use
]]
placeTorch=true
torchSlot=3

--[[
    if chests should be placed 
    when inventory is full
    
    and which slot to use
]]
placeChest=true
chestSlot=2

--[[
    Depth: length in number of blocks of the main shaft
    Width: length in number of blocks of the sub shafts
]]
miningDepth=100
miningWidth=20

--[[ 
    choose between 2 and 3
    chests will always be placed above turtle (at hight 3)
]]
shaftHight=3

-- should stones like cobblestone and tuff etc be dropped
dropStone=true
```
