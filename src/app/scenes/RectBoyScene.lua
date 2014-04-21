-- Author: Hua Liang[Stupid ET] <et@everet.org>

local RectBoyScene = class("RectBoyScene", function()
    local scene = cc.Scene:create()                            
    scene.name = "RectBoyScene"
    return scene
end)

function RectBoyScene:ctor()
    local schedulerID = 0

    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))

    local function bindEvent()
        local function onTouchEnded(touch, event)
            local location = touch:getLocation()
            local x, y = layer.boy:getPosition()
            layer.boy:setPosition(x + 10, y)
        end

        local touchListener = cc.EventListenerTouchOneByOne:create()
        touchListener:registerScriptHandler(function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)
        touchListener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
        local eventDispatcher = layer:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, layer)
    end

    local function createRectBoy()
        local textureBoy = cc.Director:getInstance():getTextureCache():addImage("boy.png")
        local rect = cc.rect(0, 0, 512, 512)
        local frame0 = cc.SpriteFrame:createWithTexture(textureBoy, rect)
        rect = cc.rect(512, 0, 512, 512)
        local frame1 = cc.SpriteFrame:createWithTexture(textureBoy, rect)
        
        local spriteBoy = cc.Sprite:createWithSpriteFrame(frame0)
        local size = spriteBoy:getContentSize()
        spriteBoy:setScale(40 / size.width, 40 / size.height)

        local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.1)
        local animate = cc.Animate:create(animation);
        spriteBoy:runAction(cc.RepeatForever:create(animate))

        spriteBoy:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 4 * 3)

        layer:addChild(spriteBoy)

        layer.boy = spriteBoy
    end
    
    local function onEnter()
        bindEvent()
        createRectBoy()
    end

    local function onNodeEvent(event)
        if "enter" == event then
            onEnter()
        end
    end

    layer:registerScriptHandler(onNodeEvent)

    self:addChild(layer)
end

return RectBoyScene
