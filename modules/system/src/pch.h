#pragma once

#include <memory>

#include <string>

#include <vector>
#include <list>
#include <map>

#include <iostream>

#include <chrono>
//#include <time.h>

#if BABYLON_OS_MAC
#if __OBJC__

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#endif
#elif BABYLON_OS_WIN

#include <Windows.h>

#endif
