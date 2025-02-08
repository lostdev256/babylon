#pragma once

namespace Babylon::Platform
{

class IPlatformContext;
using IPlatformContextPtr = std::shared_ptr<IPlatformContext>;

class IPlatformContext
{
public:
    virtual ~IPlatformContext() = default;
};

std::shared_ptr<IPlatformContext> CreatePlatformContext();

} // namespace Babylon::Platform
