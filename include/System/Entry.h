#pragma once

#include <System/App.h>

// TODO: return global static error handler result

#ifndef BABYLON_ENTRY_POINT
/**
 * Entry point to app
 * [AppDelegateClassName] - Babylon::System::IAppDelegate based class name
 */
#define BABYLON_ENTRY_POINT(AppDelegateClassName)   \
                                                    \
int main(int argc, char** argv)                     \
{                                                   \
    Babylon::System::App::Finaliser guard;          \
    auto& app = Babylon::System::App::Instance();   \
    app.UseDelegate<AppDelegateClassName>();        \
    app.Run();                                      \
    return 0;                                       \
}

#endif // BABYLON_ENTRY_POINT
