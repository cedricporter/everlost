#ifndef __EVENT_DEF_H_
#define __EVENT_DEF_H_

#include "cocos2d.h"

#define CUSTOMEVENT_TOUCH_MOVE              "touch_move"

#define CUSTOMEVENT_HERO_MOVE               "hero_move"

#define CUSTOMEVENT_PRESS_MOVE_LEFT_START         "press_move_left_start"
#define CUSTOMEVENT_PRESS_MOVE_LEFT_END           "press_move_left_end"
#define CUSTOMEVENT_PRESS_MOVE_RIGHT_START         "press_move_right_start"
#define CUSTOMEVENT_PRESS_MOVE_RIGHT_END           "press_move_right_end"


namespace cocos2d {
    struct EventHeroMove
    {
        Point originPoint;
        Point newPoint;
        
        Sprite* hero;
    };
}


#endif  // end of #ifndef __EVENT_DEF_H_