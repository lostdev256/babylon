#pragma once

#include <memory>

#include <string>

#include <list>
#include <map>
#include <vector>

#include <iostream>

#include <chrono>
// #include <time.h>

#if BABYLON_OS_MAC
#if __OBJC__

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#endif
#elif BABYLON_OS_WIN

#include <Windows.h>

#endif
