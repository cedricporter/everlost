-- Author: Hua Liang[Stupid ET] <et@everet.org>

local TileMapScene = class("TileMapScene", function()
    local scene = cc.Scene:create()                            
    scene.name = "TileMapScene"
    return scene
end)

function TileMapScene:ctor()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local layer = cc.LayerColor:create(cc.c4b(100, 100, 100, 255))
    local kTagTileMap = 100
    local kRectBoy = 101
    local boy = nil
    local map = nil
    
    local function createRectBoy()
        local textureBoy = cc.Director:getInstance():getTextureCache():addImage("boy.png")
        local rect = cc.rect(0, 0, 40, 40)
        local frame0 = cc.SpriteFrame:createWithTexture(textureBoy, rect)
        rect = cc.rect(40, 0, 40, 40)
        local frame1 = cc.SpriteFrame:createWithTexture(textureBoy, rect)
        
        local spriteBoy = cc.Sprite:createWithSpriteFrame(frame0)
        local size = spriteBoy:getContentSize()

        local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.1)
        local animate = cc.Animate:create(animation)
        spriteBoy:runAction(cc.RepeatForever:create(animate))
        spriteBoy:setTag(kRectBoy)

        spriteBoy:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 4 * 3)
        spriteBoy.speed = 0

        return spriteBoy
    end

    local function getTilePos(pt)
        local x, y = pt.x, pt.y
        mapX, mapY = map:getPosition()
        local offsetX, offsetY = mapX - origin.x, mapY - origin.y
        -- offsetX, offsetY = 0, 0
        
        x = (x - offsetX) / map:getTileSize().width
        y = (map:getMapSize().height * map:getTileSize().height - (y - offsetY)) / map:getTileSize().height
        return math.floor(x), math.floor(y)
    end

    local function update(delta)
        local g = 98
        local x, y = boy:getPosition()
        boy.speed = boy.speed + g * delta
        
        x, y = x, y - boy.speed * delta
        local boyX, boyY = x, y
        local mapOffsetY = 0

        -- x, y = x - boy:getContentSize().width / 2, y - boy:getContentSize().height / 2
        tileX, tileY = getTilePos(cc.p(x, y))
        log.debug("pos (%s, %s)", tileX, tileY)

        if boyY < 200 then
            mapOffsetY = boy:getPositionY() - boyY
            boyY = 200
        end

        if 0 <= tileX and tileX < map:getMapSize().width and 0 <= tileY and tileY < map:getMapSize().height then
            local metaLayer = map:getLayer("Meta")
            local GID = metaLayer:getTileGIDAt(cc.p(tileX, tileY))
            if GID and GID ~= 0 then
                log.debug("GID: %s", GID)
                local prop = map:getPropertiesForGID(GID)
                if prop and prop ~= 0 then
                    collision = prop["Collidable"]
                    log.debug("collision: %s", collision)
                    if collision then
                        return
                    end
                end
            end
        end
        
        map:setPositionY(map:getPositionY() + mapOffsetY)
        boy:setPosition(cc.p(boyX, boyY))
    end
    
    local function onEnter()
        boy = createRectBoy()
        layer:addChild(boy, 2)
        
        map = cc.TMXTiledMap:create("desert.tmx")
        local metaLayer = map:getLayer("Meta")
        -- metaLayer:setVisible(false)

        map:setPosition(origin.x - (map:getMapSize().width * map:getTileSize().width - visibleSize.width) / 2 + boy:getContentSize().width / 2,
                        origin.y - (map:getMapSize().height * map:getTileSize().height - visibleSize.height) / 2 + boy:getContentSize().height / 2)
        
        layer:addChild(map, 0, kTagTileMap)
        -- map:runAction(cc.Sequence:create(cc.MoveBy:create(10, cc.p(0, -1200)), cc.MoveBy:create(10, cc.p(0, 1200))))

        local schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(update, 0, false)
    end

    local function onNodeEvent(event)
        if "enter" == event then
            onEnter()
        end
    end

    layer:registerScriptHandler(onNodeEvent)

    self:addChild(layer)
end

return TileMapScene
