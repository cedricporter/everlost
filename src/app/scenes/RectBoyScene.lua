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
            layer.boy:setPositionY(y + 50)
            layer.boy.speed = 0
        end

        local touchListener = cc.EventListenerTouchOneByOne:create()
        touchListener:registerScriptHandler(function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)
        touchListener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
        local eventDispatcher = layer:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, layer)
    end

    local function createRectBoy()
        local textureBoy = cc.Director:getInstance():getTextureCache():addImage("boy.png")
        local rect = cc.rect(0, 0, 40, 40)
        local frame0 = cc.SpriteFrame:createWithTexture(textureBoy, rect)
        rect = cc.rect(40, 0, 40, 40)
        local frame1 = cc.SpriteFrame:createWithTexture(textureBoy, rect)
        
        local spriteBoy = cc.Sprite:createWithSpriteFrame(frame0)
        local size = spriteBoy:getContentSize()

        local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.1)
        local animate = cc.Animate:create(animation);
        spriteBoy:runAction(cc.RepeatForever:create(animate))

        spriteBoy:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 4 * 3)
        spriteBoy.speed = 0

        return spriteBoy
    end
    
    local function onEnter()
        bindEvent()
        local boy = createRectBoy()
        layer:addChild(boy)
        layer.boy = boy

        local function tick(dt)
            local scale = 10
            local g = 9.8 * scale
            local x, y = boy:getPosition()
            local size = boy:getContentSize()
            local lowest = origin.y + size.height / 2
            local t = dt
            local distance = boy.speed * t
            boy.speed = boy.speed + g * t
            if y < lowest then
                y = lowest
                boy.speed = 0
            else
                y = y - distance
            end

            boy:setPositionY(y)
        end

        schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)        
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
