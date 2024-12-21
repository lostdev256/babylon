#pragma once

namespace Babylon::System
{

using IPlatformAppDelegatePtr = std::shared_ptr<class IPlatformAppDelegate>;

class IPlatformAppDelegate
{
public:
    virtual ~IPlatformAppDelegate() = default;

    virtual void OnAppSetup() {};
    virtual void OnAppTeardown() {};
    virtual void OnAppRun() {};
};

} // namespace Babylon::System
