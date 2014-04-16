
local AppBase = class("AppBase")


function AppBase:ctor(appName, packageRoot)

    self.name = appName
    self.packageRoot = packageRoot or "app"

    -- set global app
    app = self
end

function AppBase:run()
end

function AppBase:exit()
    cc.Director:getInstance():endToLua()
    os.exit()
end

function AppBase:enterScene(sceneName, args, transitionType, time, more)
    local scenePackageName = self. packageRoot .. ".scenes." .. sceneName
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(totable(args)))
    
    display.replaceScene(scene, transitionType, time, more)
end

return AppBase
