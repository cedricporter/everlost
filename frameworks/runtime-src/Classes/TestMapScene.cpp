//
//  TestMapScene.cpp
//  everlost
//
//  Created by Cedric Porter on 14-5-3.
//
//

#include "TestMapScene.h"
#include "EventDef.h"

USING_NS_CC;


bool TestMapScene::init()
{
    bool ret = false;
    do {
//        CC_BREAK_IF(! initWithPhysics());
//        getPhysicsWorld()->setDebugDrawMask(PhysicsWorld::DEBUGDRAW_ALL);
//        getPhysicsWorld()->setGravity(Vect(0, 0));
        
        int zOrder = 0;
        
        _backgroundLayer = BackgroundLayer::create();
        CC_BREAK_IF(!_backgroundLayer);
        addChild(_backgroundLayer, zOrder++);
        
        _terrianLayer = TerrianLayer::create();
        CC_BREAK_IF(!_terrianLayer);
        addChild(_terrianLayer, zOrder++);
        
        _heroLayer = HeroLayer::create();
        CC_BREAK_IF(!_heroLayer);
        addChild(_heroLayer, zOrder++);
        
        _touchLayer = TouchLayer::create();
        CC_BREAK_IF(!_touchLayer);
        addChild(_touchLayer, zOrder++);
        
        schedule(schedule_selector(TestMapScene::runLogic));
        
        ret = true;
    } while (0);
    
    return ret;
}


void TestMapScene::runLogic(float delta)
{
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    auto hero = _heroLayer->getHero();
    auto heroPt = hero->getPosition();
    
    auto middlePt = Point(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2);
    auto offset = middlePt - heroPt;
    
//    log("offset %f %f", offset.x, offset.y);
    
    hero->setPosition(middlePt);
    _terrianLayer->setPosition(_terrianLayer->getPosition() + offset);
}


bool HeroLayer::init()
{
    bool ret = false;
    do {
        CC_BREAK_IF(!Layer::init());
        
        Size visibleSize = Director::getInstance()->getVisibleSize();
        Point origin = Director::getInstance()->getVisibleOrigin();
        
        _hero = Sprite::create("close.png");
        CC_BREAK_IF(!_hero);
        auto body = PhysicsBody::createCircle(_hero->getContentSize().width / 2);
        _hero->setPhysicsBody(body);
        
        _hero->setPosition(Point(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2));
        this->addChild(_hero);
        
        auto listener = EventListenerCustom::create(CUSTOMEVENT_PRESS_MOVE_RIGHT_START, [this](EventCustom* event) {
            this->moveHeroRight();
        });
        _eventDispatcher->addEventListenerWithFixedPriority(listener, 1);
        listener = EventListenerCustom::create(CUSTOMEVENT_PRESS_MOVE_LEFT_START, [this](EventCustom* event) {
            this->moveHeroLeft();
        });
        _eventDispatcher->addEventListenerWithFixedPriority(listener, 1);
        
        ret = true;
    } while (0);
    return ret;
}


bool HeroLayer::moveHero(cocos2d::Point &newPt)
{
    bool ret = false;
    
    EventHeroMove evHeroMove;
    evHeroMove.originPoint = _hero->getPosition();
    evHeroMove.newPoint = newPt;
    evHeroMove.hero = _hero;
    
    _hero->runAction(MoveBy::create(0.3, evHeroMove.newPoint - evHeroMove.originPoint));
    
    EventCustom ev(CUSTOMEVENT_HERO_MOVE);
    ev.setUserData(&evHeroMove);
    _eventDispatcher->dispatchEvent(&ev);
    
    ret = true;
    return ret;
}


bool HeroLayer::moveHeroLeft()
{
    auto pt = _hero->getPosition();
    auto newPt = pt - Point(10, 0);
    
    moveHero(newPt);

    return true;
}


bool HeroLayer::moveHeroRight()
{
    auto pt = _hero->getPosition();
    auto newPt = pt + Point(10, 0);
    
    moveHero(newPt);

    return true;
}

void HeroLayer::runLogic(float delta)
{
}


bool BackgroundLayer::init()
{
    return Layer::init();
}


void BackgroundLayer::runLogic(float delta)
{
}


bool TerrianLayer::init()
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
                log("(%d, %d), i %ld", x, y, i);
                auto pt = Point(x * map->getTileSize().width, y * map->getTileSize().height);
                node->setPosition(origin + pt);
                log("pos (%f, %f)", node->getPosition().x, node->getPosition().y);
                log("pt (%f, %f)", pt.x, pt.y);
                auto body = PhysicsBody::createBox(map->getTileSize());
                body->setDynamic(false);
                node->setPhysicsBody(body);
            }
        }
        
//        auto listener = EventListenerCustom::create(CUSTOMEVENT_HERO_MOVE, [this](EventCustom* event) {
//            EventHeroMove* ev = static_cast<EventHeroMove*>(event->getUserData());
//            Point pt = this->getPosition() - (ev->newPoint - ev->originPoint);
//        });
//        _eventDispatcher->addEventListenerWithFixedPriority(listener, 1);
        
        ret = true;
    } while (0);
    return ret;
}



TouchLayer::TouchLayer()
: _isTouching(false)
{
}


bool TouchLayer::init()
{
    bool ret = false;
    do {
        auto touchListner = EventListenerTouchOneByOne::create();
        touchListner->onTouchBegan = [this](Touch* touch, Event* event) -> bool
        {
            log("touch begin");
            _touchStartPoint = touch->getLocation();
            _isTouching = true;
            return true;
        };
        touchListner->onTouchMoved = [this](Touch* touch, Event* event)
        {
            _touchCurrentPoint = touch->getLocation();
        };
        touchListner->onTouchEnded = [this](Touch* touch, Event* event)
        {
            log("touch end");
            _isTouching = false;
        };
        _eventDispatcher->addEventListenerWithSceneGraphPriority(touchListner, this);
        
        schedule(schedule_selector(TouchLayer::update));
        
        ret = true;
    } while (0);
    return Layer::init();
}


void TouchLayer::update(float delta)
{
    if (_isTouching)
    {
        auto vect = _touchCurrentPoint - _touchStartPoint;
        EventCustom* ev;
        if (abs(vect.x) >= abs(vect.y)) // horizon move
        {
            if (vect.x >= 0)
            {
                ev = new EventCustom(CUSTOMEVENT_PRESS_MOVE_RIGHT_START);
            }
            else
            {
                ev = new EventCustom(CUSTOMEVENT_PRESS_MOVE_LEFT_START);
            }
            _eventDispatcher->dispatchEvent(ev);
            CC_SAFE_DELETE(ev);
        }
        else
        {
            
        }
    }
}
