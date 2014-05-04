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
    class TestMapScene : public Layer
    {
    public:
        virtual bool init();
        
        CREATE_FUNC(TestMapScene);
    };
} // end of namespace cocos2d

#endif /* defined(__everlost__TestMapScene__) */
