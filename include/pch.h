#pragma once

#include <memory>

#include <string>

#include <vector>
#include <list>
#include <map>

#include <iostream>

#include <chrono>
//#include <time.h>

#if BN_OS_MAC
#if __OBJC__

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#endif
#elif BN_OS_WIN

#include <Windows.h>

#endif
