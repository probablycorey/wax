#ifndef MOB_DEBUG_H
#define MOB_DEBUG_H



/** 2015.07.30 10:34:48
 *  depend: lua
 *  use lua debug tool like ZeroBraneStudio
 *  eg: require('mobdebug').start() or require('mobdebug').start('YOUR_MAC_IP_ADDRESS') in iPhone
 */
void luaopen_mobdebug_scripts(void* L);

#endif