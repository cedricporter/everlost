-- Author: Hua Liang[Stupid ET] <et@everet.org>

require "Cocos2d"
require "Cocos2dConstants"
require "util"

gmap = gmap or {}

function gmap.makeWall(point, size)
    local box = cc.Sprite:create()

    box:setScaleX(size.width/100.0);
    box:setScaleY(size.height/100.0);
    box:setPosition(cc.p(point.x, point.y));

    local body = cc.PhysicsBody:createBox(size);
    body:setDynamic(false)
    box:setPhysicsBody(body);

    return box;
end
