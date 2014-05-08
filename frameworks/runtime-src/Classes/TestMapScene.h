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
    
    
    class TestMapScene : public Node
    {
    public:
        static Scene* createScene();
            
        CREATE_FUNC(TestMapScene);
    };
} // end of namespace cocos2d

#endif /* defined(__everlost__TestMapScene__) */
