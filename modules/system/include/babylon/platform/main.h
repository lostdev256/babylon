#pragma once

#include <System/App.h>

#if BN_OS_MAC

#define BN_ENTRY_POINT_IMPL(TAppConfigurator)                  \
int main(int argc, char** argv)                                \
{                                                              \
    babylon::System::App::Entry<TAppConfigurator>({ argc, argv });  \
    return 0;                                                  \
}

#elif BN_OS_WIN

#define BN_ENTRY_POINT_IMPL(TAppConfigurator)                  \
int main(int argc, char** argv)                                \
{                                                              \
    babylon::System::App::Entry<TAppConfigurator>({ argc, argv });  \
    return 0;                                                  \
}

#else

#error Target platform not supported

#endif
