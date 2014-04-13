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

    require "util"
    
    --support debug
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or 
        (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
    (cc.PLATFORM_OS_MAC == targetPlatform) then
        log.info("result is ")
        --require('debugger')()
        
    end

    ---------------

    require "game_logic"
    game_main()

end


xpcall(main, __G__TRACKBACK__)
