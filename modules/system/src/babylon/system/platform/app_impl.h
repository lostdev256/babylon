#pragma once

#if BABYLON_OS_MAC
#include <system/platform/mac/app_impl.h>
#elif BABYLON_OS_WIN
#include <system/platform/win/app_impl.h>
#else
#error Target platform not supported
#endif
