#pragma once

#if BABYLON_OS_MAC

#define BABYLON_ENTRY_POINT_IMPL(TConfigurator)                     \
    int main(int argc, char** argv)                                 \
    {                                                               \
        babylon::system::app::entry<TConfigurator>({ argc, argv }); \
        return 0;                                                   \
    }

#elif BABYLON_OS_WIN

#define BABYLON_ENTRY_POINT_IMPL(TConfigurator)                     \
    int main(int argc, char** argv)                                 \
    {                                                               \
        babylon::system::app::entry<TConfigurator>({ argc, argv }); \
        return 0;                                                   \
    }

#else

#error Target platform not supported

#endif
