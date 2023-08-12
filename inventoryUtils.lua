require ".utils"

items_to_drop = {"minecraft:cobblestone", "minecraft:cobbled_deepslate", "minecraft:mossy_cobblestonethen", "minecraft:granite", "minecraft:gravel", "minecraft:dirt", "minecraft:tuff", "minecraft:andesite"}
function dropStonef ()
    for i=1, 16, 1 do
        item = turtle.getItemDetail(i)
        if item then
            print(item.name)
            if has_value(items_to_drop, item.name ) then
                turtle.select(i)
                turtle.drop()        
            end 
        end
    end
end
