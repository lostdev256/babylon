#pragma once

#include <memory>

namespace Babylon::System
{

using IAppDelegateUPtr = std::unique_ptr<class IAppDelegate>;

class IAppDelegate
{
public:
    virtual ~IAppDelegate() = default;

    virtual void OnAppSetup() {};
    virtual void OnAppTeardown() {};
    virtual void OnAppRun() {};
};

} // namespace Babylon::System
