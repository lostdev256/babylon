#pragma once

#include <Platform/Main.h>

/**
 * Entry point to app
 * [AppDelegateClassName] - Babylon::System::IAppDelegate based class name
 */
#define BABYLON_ENTRY_POINT(AppDelegateClassName) BABYLON_ENTRY_POINT_IMPL(AppDelegateClassName)
