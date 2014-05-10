#include "lua_cocos2dx_custom.hpp"
#include "TestMapScene.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cocos2dx_custom_TestMapScene_init(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::TestMapScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.TestMapScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::TestMapScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_TestMapScene_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_TestMapScene_init'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_TestMapScene_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"cc.TestMapScene",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        cocos2d::TestMapScene* ret = cocos2d::TestMapScene::create();
        object_to_luaval<cocos2d::TestMapScene>(tolua_S, "cc.TestMapScene",(cocos2d::TestMapScene*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_TestMapScene_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cocos2dx_custom_TestMapScene_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (TestMapScene)");
    return 0;
}

int lua_register_cocos2dx_custom_TestMapScene(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"cc.TestMapScene");
    tolua_cclass(tolua_S,"TestMapScene","cc.TestMapScene","cc.Scene",nullptr);

    tolua_beginmodule(tolua_S,"TestMapScene");
        tolua_function(tolua_S,"init",lua_cocos2dx_custom_TestMapScene_init);
        tolua_function(tolua_S,"create", lua_cocos2dx_custom_TestMapScene_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(cocos2d::TestMapScene).name();
    g_luaType[typeName] = "cc.TestMapScene";
    g_typeCast["TestMapScene"] = "cc.TestMapScene";
    return 1;
}
TOLUA_API int register_all_cocos2dx_custom(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_cocos2dx_custom_TestMapScene(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

