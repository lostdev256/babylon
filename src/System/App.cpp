#include <pch.h>

#include <System/App.h>

namespace Babylon::System
{

void App::Init(AppArguments&& args, IAppConfiguratorPtr&& configurator)
{
    _arguments = std::move(args);
    _configurator = std::move(configurator);
    _platform_context = Platform::CreatePlatformContext();
}

} // namespace Babylon::System
