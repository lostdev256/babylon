#pragma once

#if BABYLON_OS_MAC
#include <babylon/place/platform/mac/place_impl.h>
#elif BABYLON_OS_WIN
#include <babylon/place/platform/win/place_impl.h>
#else
#error Target platform not supported
#endif
