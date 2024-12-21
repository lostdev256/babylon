#pragma once

#include <System/Entry.h>

#if BABYLON_OS_MAC

#define BABYLON_ENTRY_POINT_IMPL(AppDelegateClassName)                     \
int main(int argc, char** argv)                                            \
{                                                                          \
    return Babylon::System::Entry<AppDelegateClassName>({ argc, argv });   \
}

#else

#error Target platform not supported

#endif
