#pragma once

#include <Common/Globals.h>
#include <System/App.h>
#include <System/IAppDelegate.h>

#ifndef BS_ENTRY_POINT

/****************************************************************************
 * Entry point to app
 * [DelegatClassName] - IAppDelegate based class name
 */
#define BS_ENTRY_POINT(DelegatClassName)                            \
int main(int argc, char** argv)                                     \
{                                                                   \
    BS::App::Run<DelegatClassName>();                               \
    return 0; // TODO: return global static error handler result    \
}

#endif // BS_ENTRY_POINT
