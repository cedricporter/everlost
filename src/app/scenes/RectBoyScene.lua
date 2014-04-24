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
    local kTagGround = 100

    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local layer = cc.LayerColor:create(cc.c4b(100, 100, 100, 255))

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
        body:applyForce(cc.p(0, -98000 * 1.2))
        body:setRotationEnable(false)
        body:setVelocity(cc.p(100, 0))
        spriteBoy:setPhysicsBody(body)
        spriteBoy.body = body

        return spriteBoy
    end
    
    local function onEnter()
        bindEvent()
        local boy = createRectBoy()
        layer:addChild(boy)
        layer.boy = boy

        local groundNode = cc.Sprite:create("blank.png")
        groundNode:setTextureRect(cc.rect(0, 0, 3000, 5))
        groundNode:setColor(cc.c3b(255, 255, 255))
        groundNode:setTag(kTagGround)
        groundNode:setPhysicsBody(cc.PhysicsBody:createEdgeSegment(cc.p(-1500, 0), cc.p(1500, 0)))
        groundNode:setPosition(cc.p(origin.x + visibleSize.width / 2, origin.y + 100))
        layer:addChild(groundNode)
        

        local function tick()
            for idx, child in ipairs(layer:getChildren()) do
                log.debug("child %s", idx)
                if child:getTag() ~= kTagGround and child:getPositionX() < 0 then
                    child:removeFromParent()
                end
            end

            if #layer:getChildren() < 8 then
                for i = 0, 10 do
                    local node = cc.Sprite:create("blank.png")
                    node:setTextureRect(cc.rect(0, 0, 100, 5))
                    node:setColor(cc.c3b(255, 255, 255))
                    node:setPhysicsBody(cc.PhysicsBody:createEdgeSegment(cc.p(-50, 0), cc.p(50, 0)))
                    local startX = layer.boy:getPositionX()
                    node:setPosition(cc.p(math.random(startX, startX + 1000), 200 + math.random(10, 400)))
                    node:runAction(cc.RepeatForever:create(cc.MoveBy:create(0, cc.p(-1, 0))))
                    layer:addChild(node)
                end
            end
            
        end
        
        local schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
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
