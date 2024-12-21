#pragma once

namespace Babylon::System
{

using IAppDelegateUPtr = std::unique_ptr<class IAppDelegate>;

class IAppDelegate
{
public:
    template<class T>
    static IAppDelegateUPtr Create();

    virtual ~IAppDelegate() = default;

    virtual void OnAppSetup() {};
    virtual void OnAppTeardown() {};
    virtual void OnAppRun() {};
};

template<class AppDelegateClass>
IAppDelegateUPtr IAppDelegate::Create()
{
    static_assert(std::is_convertible_v<AppDelegateClass, IAppDelegate>);
    return std::make_unique<AppDelegateClass>();
}

} // namespace Babylon::System
