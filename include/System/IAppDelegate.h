#pragma once

#include <Common/Globals.h>

namespace Babylon::System
{

using IAppDelegateUPtr = std::unique_ptr<class IAppDelegate>;

class IAppDelegate
{
public:
    virtual ~IAppDelegate() = default;

    virtual void OnInit() = 0;
    virtual void OnDeinit() = 0;
    virtual void Run() = 0;
};

} // namespace Babylon::System
