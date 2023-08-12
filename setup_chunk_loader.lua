require ".utils"

print("put your chunk loader in first inventory slot.\n\nRecommended Mods:\nTurtlematic (Fabric)\nAdvanced Peripherals (Forge)\n")
if not choiceBool("Continue") then
    return
end

turtle.select(1)
turtle.equipLeft()
