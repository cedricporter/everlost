-- Author: Hua Liang[Stupid ET] <et@everet.org>

local TileMap2Scene = class("TileMap2Scene", function()
    local scene = cc.Scene:create()                            
    scene.name = "TileMap2Scene"
    return scene
end)

function TileMap2Scene:ctor()
    local kTagTileMap = 100
    local kRectBoy = 101
    
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    -- local layer = cc.LayerColor:create(cc.c4b(100, 100, 100, 255))
    local layer = cc.TestMapScene:create()

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
        spriteBoy:setScale(32/40, 32/40)
        spriteBoy:runAction(cc.RepeatForever:create(animate))
        spriteBoy:setTag(kRectBoy)

        spriteBoy:setPosition(origin.x + visibleSize.width / 4, origin.y + visibleSize.height / 4 * 3)
        spriteBoy.speed = 0

        return spriteBoy
    end
    
    local function onEnter()
        -- local map = cc.TMXTiledMap:create("map1.tmx")
        -- map:setPosition(origin)
        -- layer:addChild(map, 0, kTagTileMap)
        
        -- local metaLayer = map:getLayer("Meta")
        -- -- metaLayer:setVisible(false)
        -- local tiles = metaLayer:getTiles()
        -- log.debug("%s", tiles)

        -- local boy = createRectBoy()
        -- layer:addChild(boy, 1)
    end

    local function onNodeEvent(event)
        if "enter" == event then
            onEnter()
        end
    end

    layer:registerScriptHandler(onNodeEvent)
    self:addChild(layer)
end

return TileMap2Scene
