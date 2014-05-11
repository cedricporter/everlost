//
//  TestMapScene.h
//  everlost
//
//  Created by Cedric Porter on 14-5-3.
//
//

#ifndef __everlost__TestMapScene__
#define __everlost__TestMapScene__

#include "cocos2d.h"
#include "ui/CocosGUI.h"

namespace cocos2d {
    
    class BackgroundLayer : public Layer
    {
    public:
        virtual bool init();
        
        void runLogic(float delta);
        
        CREATE_FUNC(BackgroundLayer);
    };
    
    
    class HeroLayer : public Layer
    {
    protected:
        bool moveHero(Point& newPt);
        bool moveHeroRight();
        bool moveHeroLeft();
        bool jump();
        
    public:
        virtual bool init();
        
        void runLogic(float delta);
        
        CC_SYNTHESIZE_READONLY(Sprite*, _hero, Hero);

        CREATE_FUNC(HeroLayer);
    };
    
    
    class TerrianLayer : public Layer
    {
    public:
        virtual bool init();
        
        CREATE_FUNC(TerrianLayer);
    };
    
    
    class TouchLayer : public Layer
    {
    public:
        virtual bool init();
        
        CREATE_FUNC(TouchLayer);
        
        void update(float delta);
        
    protected:
        bool _isTouching;
        Point _touchStartPoint;
        Point _touchCurrentPoint;
        
CC_CONSTRUCTOR_ACCESS:
        TouchLayer();
    };
    
    
    class TestMapScene : public Scene
    {
    public:
        virtual bool init();
            
        CREATE_FUNC(TestMapScene);
        
    protected:
        HeroLayer* _heroLayer;
        BackgroundLayer* _backgroundLayer;
        TerrianLayer* _terrianLayer;
        TouchLayer* _touchLayer;
        
        void runLogic(float delta);
    };
} // end of namespace cocos2d

#endif /* defined(__everlost__TestMapScene__) */
