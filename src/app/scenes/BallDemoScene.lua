-- Author: Hua Liang[Stupid ET] <et@everet.org>

local BallDemoScene = class("BallDemoScene", function()
    local scene = cc.Scene:createWithPhysics()                            
    scene.name = "BallDemoScene"
    return scene
end)

function BallDemoScene:ctor()
    local schedulerID = 0

    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local layer = cc.Layer:create()

    local function addBall(point)
        local ball = cc.Sprite:create("close.png")
        local body = cc.PhysicsBody:createCircle(ball:getContentSize().width / 2)
        ball:setPhysicsBody(body)
        ball:setPosition(point)
        layer:addChild(ball)
    end

    local function createMap()
        local walls = {
            {pt=cc.p(100, 320), sz=cc.size(10, 300)},
            {pt=cc.p(700, 200), sz=cc.size(200, 20)},
        }
        for idx, value in ipairs(walls) do
            local wall = gmap.makeWall(cc.p(value.pt.x + origin.x, value.pt.y + origin.y), value.sz)
            layer:addChild(wall)
        end
    end

    local function onEnter()
        local function onTouchEnded(touch, event)
            local location = touch:getLocation()
            addBall(location)
        end

        local touchListener = cc.EventListenerTouchOneByOne:create()
        touchListener:registerScriptHandler(function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)
        touchListener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
        local eventDispatcher = layer:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, layer)

        local node = cc.Node:create()
        node:setPhysicsBody(cc.PhysicsBody:createEdgeBox(cc.size(VisibleRect:getVisibleRect().width, VisibleRect:getVisibleRect().height)))
        node:setPosition(VisibleRect:center())
        layer:addChild(node)

        log.debug("origin x " .. VisibleRect:center().x .. " y " .. VisibleRect:center().y)
        log.debug("rect width " .. VisibleRect:getVisibleRect().width .. " height " .. VisibleRect:getVisibleRect().height)
        log.debug("visibleSize rect width " .. visibleSize.width .. " height " .. visibleSize.height)

        createMap()

    end

    local function onNodeEvent(event)
        if "enter" == event then
            onEnter()
        end
    end

    layer:registerScriptHandler(onNodeEvent)
    layer:setAccelerometerEnabled(true)

    local function didAccelerate(x, y, z, timestamp)
        log.debug("didAccelerate %f, %f, %f, %f", x, y, z, timestamp)
        cc.Director:getInstance():getRunningScene():getPhysicsWorld():setGravity(cc.p(x * 1000, y * 1000))
    end
    layer:registerScriptAccelerateHandler(didAccelerate)

    self:addChild(layer)
    self:getPhysicsWorld():setGravity(cc.p(-98,-98 * 2))
    local debug = true
    self:getPhysicsWorld():setDebugDrawMask(debug and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
end

return BallDemoScene
