require "Cocos2d"
require "Cocos2dConstants"
require "util"

function makeBox(point, size, color)
    local box = cc.Sprite:create("Images/YellowSquare.png") 
    
    box:setScaleX(size.width/100.0);
    box:setScaleY(size.height/100.0);
    
    local body = cc.PhysicsBody:createBox(size);
    box:setPhysicsBody(body);
    box:setPosition(cc.p(point.x, point.y));
    
    return box;
end
