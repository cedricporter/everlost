
local MyApp = class("MyApp", mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}
end

function MyApp:run()
    -- self:enterBallDemoScene()
    self:enterRectBoyScene()
end

function MyApp:enterBallDemoScene()
    self:enterScene("BallDemoScene", nil, "fade", 0.6, nil)
end

function MyApp:enterRectBoyScene()
    self:enterScene("RectBoyScene", nil, "fade", 0.6, nil)
end

return MyApp
