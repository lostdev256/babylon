#pragma once

#include <System/App.h>

#if BABYLON_OS_MAC

#define BABYLON_ENTRY_POINT_IMPL(TAppConfigurator)                  \
int main(int argc, char** argv)                                     \
{                                                                   \
    Babylon::System::App::Entry<TAppConfigurator>({ argc, argv });  \
    return 0;                                                       \
}

#else

#error Target platform not supported

#endif
