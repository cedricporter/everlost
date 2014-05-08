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
    
    auto backgroundLayer = BackgroundLayer::create();
    scene->addChild(backgroundLayer);
    
    auto playerLayer = HeroLayer::create();
    scene->addChild(playerLayer);
    
    return scene;
}


bool HeroLayer::init()
{
    _isTouching = false;
    
    bool ret = false;
    do {
        CC_BREAK_IF(!Layer::init());
        
        Size visibleSize = Director::getInstance()->getVisibleSize();
        Point origin = Director::getInstance()->getVisibleOrigin();
        
        auto node = Sprite::create("close.png");
        _hero = node;
        CC_BREAK_IF(!node);
        auto body = PhysicsBody::createCircle(node->getContentSize().width / 2);
        node->setPhysicsBody(body);
        
        node->setPosition(Point(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2));
        this->addChild(node);
        
        auto touchListner = EventListenerTouchOneByOne::create();
        touchListner->onTouchBegan = [this](Touch* touch, Event* event) -> bool
        {
            this->_isTouching = true;
            return true;
        };
        touchListner->onTouchMoved = [this](Touch* touch, Event* event)
        {
            if (this->_isTouching)
            {
                auto body = this->_hero->getPhysicsBody();
                auto location = touch->getLocation();
                auto offset = location - body->getPosition();
                
                body->applyImpulse(Vect(offset.x * 100, offset.y * 100));
            }
        };
        touchListner->onTouchEnded = [this](Touch* touch, Event* event)
        {
            this->_isTouching = false;
        };
        _eventDispatcher->addEventListenerWithSceneGraphPriority(touchListner, this);
        
        schedule(schedule_selector(HeroLayer::runLogic), 0);
        
        ret = true;
    } while (0);
return ret;
}


void HeroLayer::runLogic(float delta)
{
    log("H %f", delta);
}


bool BackgroundLayer::init()
{
    bool ret = false;
    do {
        CC_BREAK_IF(!Layer::init());
        
        Size visibleSize = Director::getInstance()->getVisibleSize();
        Point origin = Director::getInstance()->getVisibleOrigin();
        
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
        
        schedule(schedule_selector(BackgroundLayer::runLogic), 0);
        
        ret = true;
    } while (0);
    return ret;
}


void BackgroundLayer::runLogic(float delta)
{
    log("B %f", delta);
}
