#include <pch.h>

#include <System/App.h>

#include <Platform/Platform.h>

namespace BN::System
{

bool App::Init(AppArguments&& args, IAppConfiguratorPtr&& configurator)
{
    _arguments = std::move(args);
    _configurator = std::move(configurator);
    _controller = IAppController::Create();

    if (!_controller)
    {
        return false;
    }

    return true;
}

void App::Run() const
{
    _controller->Control();
}

} // namespace BN::System
