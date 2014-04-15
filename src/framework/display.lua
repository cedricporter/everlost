
local display = {}

local sharedDirector         = cc.Director:getInstance()

-- check device screen size
local glview = sharedDirector:getOpenGLView()
local size = glview:getFrameSize()
display.sizeInPixels = {width = size.width, height = size.height}

local w = display.sizeInPixels.width
local h = display.sizeInPixels.height


function display.newScene(name)
    local scene = cc.Scene:create()
    scene.name = name or "<unknown-scene>"
    return scene
end
