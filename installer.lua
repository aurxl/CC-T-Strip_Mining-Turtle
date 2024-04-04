local github_url = "https://raw.githubusercontent.com/aurxl/CC-T-Strip_Mining-Turtle/main/"
local files = {
    "config.lua",
    "mining.lua",
    "miningUtils.lua",
    "setup_chunk_loader.lua",
    "utils.lua",
    "startup.lua"
}

io.write("Start Downloading files.\n")
for index, filename in ipairs(files) do
    local request, file_content, file
    local download_path =  github_url .. filename
    
    io.write(index .. "/" .. #files .. " " .. filename .. " ... ")
    request = http.get(download_path)

    if not request then
        io.write("failure\n")
    else
        file_content = request.readAll()
        request.close()
        file = io.open(filename, "w")
        file:write(file_content)
        file:close()

        io.write("success\n")
    end
end

