//
//  TestMapScene.cpp
//  everlost
//
//  Created by Cedric Porter on 14-5-3.
//
//

#include "TestMapScene.h"

USING_NS_CC;


bool TestMapScene::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    bool ret = false;
    do {
        auto node = Sprite::create("close.png");
        CC_BREAK_IF(!node);
        
        node->setPosition(Point(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2));
        this->addChild(node);
        
        auto map = TMXTiledMap::create("map1.tmx");
        this->addChild(map, 0, 101);
        auto metaLayer = map->getLayer("Meta");
        
        ret = true;
    } while (0);
    return ret;
}