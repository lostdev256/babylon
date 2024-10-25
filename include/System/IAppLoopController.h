#pragma once

#include <memory>

namespace Babylon::System
{

using IAppLoopControllerPtr = std::shared_ptr<class IAppLoopController>;

class IAppLoopController
{
public:
    virtual ~IAppLoopController() = default;

    virtual void Run() = 0;
};

} // namespace Babylon::System
