
local MyApp = class("MyApp", mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}
end

function MyApp:run()
    self:enterBallDemoScene()
end

function MyApp:enterBallDemoScene()
    self:enterScene("BallDemoScene", nil, "fade", 0.6, nil)
end

return MyApp
