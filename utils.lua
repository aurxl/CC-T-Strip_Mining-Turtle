--[[
    params:
        prompt string: what will be displayed as choice
]]

function choiceBool (prompt)
    while true do
        io.write(prompt, "(Y/n): ")
        context = read()
        if context == "y" or context == "Y" or context == "yes" or context == "" then
            return true
        elseif context == "n" or context == "N" or context == "no" then
            return false
        else
            print("falsche Eingabe")
        end
    end
end

--[[
    params:
        prompt string: what will be displayed as choice
        default: default value
]]

function choiceNumber (prompt, default)
    default = default or nil
    while true do
        if default == nil then
            io.write(prompt,": ")
        else
            io.write(prompt, "(", default, "): ")
        end
        number = read()
        if type(tonumber(number)) == "number" then 
            return number
        elseif number == "" then
            return default
        else
            print("falsche Eingabe")
        end
    end
end

--[[
    params:
        prompt string: what will be displayed as choice
        scope list: possabilites to choose from
]]

function choice (prompt, scope)
    while true do
        io.write(prompt, " :")
        context = read()
        for i, item in pairs(scope) do
            if context == item then
                return item
            end
        end
        print("falsche Eingabe")
    end
end

function getGPS ()
    local coor = gps.locate(5)
    if x == nil then
        return false
    else 
        return coor
    end
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            do return true end
         end
    end

    do return false end
end
