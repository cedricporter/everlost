require "Cocos2d"
require "Cocos2dConstants"

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    log.error("----------------------------------------")
    log.error("LUA ERROR: " .. tostring(msg) .. "\n")
    log.error(debug.traceback())
    log.error("----------------------------------------")
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    cc.FileUtils:getInstance():addSearchResolutionsOrder("src");
    cc.FileUtils:getInstance():addSearchResolutionsOrder("res");
    cc.FileUtils:getInstance():addSearchResolutionsOrder("res/tmap");

    require "util"
    require "map"
    require "framework.init"
    
    ---------------
    config = require("app.config")
    config.debug = true
    
    --support debug
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_ANDROID == targetPlatform then
        config.debug = false
        log.info("disable debug ")
    end
    
    require("app.MyApp").new():run()

    -- local sceneGame = import("scenes.BallDemoScene").new()
    -- if cc.Director:getInstance():getRunningScene() then
    --     cc.Director:getInstance():replaceScene(sceneGame)
    -- else
    --     cc.Director:getInstance():runWithScene(sceneGame)
    -- end

end


xpcall(main, __G__TRACKBACK__)
