#pragma once

#include <babylon/system/app.h>

#if BABYLON_OS_MAC

#define BABYLON_ENTRY_POINT_IMPL(TConfigurator)                             \
    int main(int argc, char** argv)                                         \
    {                                                                       \
        return babylon::system::app::entry<TConfigurator>({ argc, argv });  \
    }

#elif BABYLON_OS_WIN

#define BABYLON_ENTRY_POINT_IMPL(TConfigurator)                             \
    int main(int argc, char** argv)                                         \
    {                                                                       \
        return babylon::system::app::entry<TConfigurator>({ argc, argv });  \
    }

#else

#error Target platform not supported

#endif
