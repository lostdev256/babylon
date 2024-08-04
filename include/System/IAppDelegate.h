#pragma once

#include <memory>

namespace Babylon::System
{

using IAppDelegateUPtr = std::unique_ptr<class IAppDelegate>;

class IAppDelegate
{
public:
    virtual ~IAppDelegate() = default;

    virtual void Init() {};
    virtual void DeInit() {};
    virtual void Run() {};
};

} // namespace Babylon::System
