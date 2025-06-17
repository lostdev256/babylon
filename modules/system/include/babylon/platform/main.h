#pragma once

#include <babylon/system/app.h>

#if BN_OS_MAC

#define BN_ENTRY_POINT_IMPL(TConfigurator)                          \
int main(int argc, char** argv)                                     \
{                                                                   \
    babylon::system::app::entry<TConfigurator>({ argc, argv });     \
    return 0;                                                       \
}

#elif BN_OS_WIN

#define BN_ENTRY_POINT_IMPL(TConfigurator)                          \
int main(int argc, char** argv)                                     \
{                                                                   \
    babylon::system::app::entry<TConfigurator>({ argc, argv });     \
    return 0;                                                       \
}

#else

#error Target platform not supported

#endif
