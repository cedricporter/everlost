-- Author: Hua Liang[Stupid ET] <et@everet.org>

local RectBoyScene = class("RectBoyScene", function()
    local scene = cc.Scene:createWithPhysics()                            
    scene.name = "RectBoyScene"
    scene:getPhysicsWorld():setGravity(cc.p(0, 0))
    scene:getPhysicsWorld():setDebugDrawMask(config.debug and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)    
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
            -- layer.boy:getPhysicsBody():applyImpulse(cc.p(0, 9800 * 4))
            layer.boy:getPhysicsBody():setVelocity(cc.p(0, 400))
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
        
        local body = cc.PhysicsBody:createBox(spriteBoy:getContentSize())
        body:applyForce(cc.p(0, -98000))
        body:setRotationEnable(false)
        body:setVelocity(cc.p(100, 0))
        spriteBoy:setPhysicsBody(body)

        return spriteBoy
    end
    
    local function onEnter()
        bindEvent()
        local boy = createRectBoy()
        layer:addChild(boy)
        layer.boy = boy

        local node = cc.Node:create()
        node:setPhysicsBody(cc.PhysicsBody:createEdgeSegment(cc.p(0, 0), cc.p(20000, 0)))
        node:setPosition(cc.p(origin.x - 10000, origin.y + 100))
        layer:addChild(node)

        for i = 0, 100 do
            local node = cc.Node:create()
            node:setPhysicsBody(cc.PhysicsBody:createEdgeSegment(cc.p(0, 0), cc.p(100, 0)))
            node:setPosition(cc.p(origin.x + math.random(0, 10000), origin.y + 200 + math.random(0, 200)))
            layer:addChild(node)
        end
        
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
