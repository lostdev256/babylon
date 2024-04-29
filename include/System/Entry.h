#pragma once

#include <Common/Globals.h>
#include <System/Core.h>
#include <System/App.h>
#include <System/IAppDelegate.h>

#ifndef BABYLON_ENTRY_POINT

 // TODO: return global static error handler result 
 
/****************************************************************************
 * Entry point to app
 * [DelegatClassName] - IAppDelegate based class name
 */
#define BABYLON_ENTRY_POINT(DelegatClassName)                       \
int main(int argc, char** argv)                                     \
{                                                                   \
    Babylon::System::Core::Run<DelegatClassName>();                 \
    return 0;                                                       \
}

#endif // BABYLON_ENTRY_POINT
