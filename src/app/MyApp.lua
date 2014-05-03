
local MyApp = class("MyApp", mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}
end

function MyApp:run()
    -- self:enterBallDemoScene()
    -- self:enterRectBoyScene()
    self:enterTileMapScene()
end

function MyApp:enterBallDemoScene()
    self:enterScene("BallDemoScene", nil, "fade", 0.6, nil)
end

function MyApp:enterRectBoyScene()
    self:enterScene("RectBoyScene", nil, "fade", 0.6, nil)
end

function MyApp:enterTileMapScene()
    self:enterScene("TileMapScene", nil, "fade", 0.6, nil)
end

return MyApp
