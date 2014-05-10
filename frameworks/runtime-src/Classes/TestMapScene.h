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
        Sprite *_hero;
        
    public:
        virtual bool init();
        
        void runLogic(float delta);
        
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
        
    protected:
        bool _isTouching;
        
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
    };
} // end of namespace cocos2d

#endif /* defined(__everlost__TestMapScene__) */
