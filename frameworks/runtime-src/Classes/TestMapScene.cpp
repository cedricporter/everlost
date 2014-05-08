//
//  TestMapScene.cpp
//  everlost
//
//  Created by Cedric Porter on 14-5-3.
//
//

#include "TestMapScene.h"

USING_NS_CC;


Scene* TestMapScene::createScene()
{
    auto scene = Scene::createWithPhysics();
    scene->getPhysicsWorld()->setDebugDrawMask(PhysicsWorld::DEBUGDRAW_ALL);
    
    auto layer = BackgroundLayer::create();
    scene->addChild(layer);
    
    return scene;
}


bool BackgroundLayer::init()
{
    bool ret = false;
    do {
        CC_BREAK_IF(!Layer::init());
        
        Size visibleSize = Director::getInstance()->getVisibleSize();
        Point origin = Director::getInstance()->getVisibleOrigin();
        
        auto node = Sprite::create("close.png");
        CC_BREAK_IF(!node);
        auto body = PhysicsBody::createCircle(node->getContentSize().width / 2);
        node->setPhysicsBody(body);
        
        node->setPosition(Point(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2));
        this->addChild(node);
        
        auto map = TMXTiledMap::create("map1.tmx");
        map->setPosition(origin.x - map->getTileSize().width / 2, origin.y + map->getTileSize().height / 2);
        this->addChild(map, 0, 101);
        
        auto collisionLayer = map->getLayer("Collision");
        auto pTile = collisionLayer->getTiles();
        Size size = collisionLayer->getLayerSize();
        for (ssize_t i = 0; i < size.width * size.height; i++)
        {
            auto tileGid = pTile[i];
            auto prop = map->getPropertiesForGID(tileGid).asValueMap();
            auto collision = prop["Collidable"];
            auto Collidable = collision.asString();
            if (! Collidable.empty() && Collidable == "True") {
                auto node = Node::create();
                this->addChild(node);
                Size sz = collisionLayer->getLayerSize();
                int y = i / collisionLayer->getLayerSize().width;
                int x = i - y * collisionLayer->getLayerSize().width;
                y = collisionLayer->getLayerSize().height - y;
                log("(%d, %d), i %d", x, y, i);
                auto pt = Point(x * map->getTileSize().width, y * map->getTileSize().height);
                node->setPosition(origin + pt);
                log("pos (%f, %f)", node->getPosition().x, node->getPosition().y);
                log("pt (%f, %f)", pt.x, pt.y);
                auto body = PhysicsBody::createBox(map->getTileSize());
                body->setDynamic(false);
                node->setPhysicsBody(body);
            }
        }
        
        auto touchListner = EventListenerTouchOneByOne::create();
        bool touchMoved = false;
        touchListner->onTouchBegan = [this, &touchMoved](Touch* touch, Event* event) -> bool
        {
            touchMoved = true;
            return true;
        };
        touchListner->onTouchMoved = [this, body, &touchMoved](Touch* touch, Event* event)
        {
            if (touchMoved)
            {
                auto location = touch->getLocation();
                
                auto offset = location - body->getPosition();
                
                body->applyImpulse(Vect(offset.x * 100, offset.y * 100));
            }
        };
        touchListner->onTouchEnded = [this, &touchMoved](Touch* touch, Event* event)
        {
            touchMoved = false;
        };
        _eventDispatcher->addEventListenerWithSceneGraphPriority(touchListner, this);
        
        schedule(schedule_selector(BackgroundLayer::runLogic), 0);
        
        ret = true;
    } while (0);
    return ret;
}


void BackgroundLayer::runLogic(float delta)
{
    log("%f", delta);
}