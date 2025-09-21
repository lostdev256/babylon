#pragma once

#if BABYLON_OS_MAC and __OBJC__

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#elif BABYLON_OS_WIN

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>

#endif
