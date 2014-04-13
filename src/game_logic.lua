require "Cocos2d"
require "Cocos2dConstants"
require "util"

function game_main()
    local schedulerID = 0
    
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local function creatDog()
        local frameWidth = 105
        local frameHeight = 95

        -- create dog animate
        local textureDog = cc.Director:getInstance():getTextureCache():addImage("dog.png")
        local rect = cc.rect(0, 0, frameWidth, frameHeight)
        local frame0 = cc.SpriteFrame:createWithTexture(textureDog, rect)
        rect = cc.rect(frameWidth, 0, frameWidth, frameHeight)
        local frame1 = cc.SpriteFrame:createWithTexture(textureDog, rect)

        local spriteDog = cc.Sprite:createWithSpriteFrame(frame0)
        spriteDog.isPaused = false
        spriteDog:setPosition(origin.x, origin.y + visibleSize.height / 4 * 3)

        local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.1)
        local animate = cc.Animate:create(animation);
        spriteDog:runAction(cc.RepeatForever:create(animate))

        -- moving dog at every frame
        local function tick()
            if spriteDog.isPaused then return end
            local x, y = spriteDog:getPosition()
            if x < origin.x then
                x = origin.x + visibleSize.width
            else
                x = x - 2
            end

            spriteDog:setPositionX(x)
        end

        schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)

        return spriteDog
    end

    local function createPhysicsDemo()
	local layer = cc.Layer:create()

	local function addBall(point)
	    local ball = cc.Sprite:create("close.png")
	    local body = cc.PhysicsBody:createCircle(ball:getContentSize().width / 2)
	    ball:setPhysicsBody(body)
	    ball:setPosition(point)
	    layer:addChild(ball)
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
	    
	    log.debug("origin x " .. VisibleRect:center().x .. " y " .. VisibleRect:center().y)
	    log.debug("rect width " .. VisibleRect:getVisibleRect().width .. " height " .. VisibleRect:getVisibleRect().height)
	    log.debug("visibleSize rect width " .. visibleSize.width .. " height " .. visibleSize.height)

	    layer:addChild(node)
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

	return layer
    end

    -- run
    local sceneGame = cc.Scene:createWithPhysics()
    sceneGame:getPhysicsWorld():setGravity(cc.p(-98,-98 * 2))
    -- sceneGame:addChild(creatDog())
    sceneGame:addChild(createPhysicsDemo())
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(sceneGame)
    else
        cc.Director:getInstance():runWithScene(sceneGame)
    end

    local debug = true
    sceneGame:getPhysicsWorld():setDebugDrawMask(debug and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)	
    
end
