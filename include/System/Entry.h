#pragma once

#include <Platform/Entry.h>
#include <System/App.h>
#include <System/AppArguments.h>
#include <System/IAppDelegate.h>

namespace Babylon::System
{

template <class AppDelegateClassName>
int Entry(AppArguments&& args)
{
    static_assert(std::is_convertible_v<AppDelegateClassName, IAppDelegate>);
    auto delegate =  std::make_unique<AppDelegateClassName>();

    App::Finaliser guard;
    auto& app = App::Instance();
    app.SetArguments(std::move(args));
    app.SetDelegate(std::move(delegate));

    return Platform::Entry();
}

} // namespace Babylon::System
