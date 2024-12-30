#include <pch.h>

#include <System/App.h>

namespace Babylon::System
{

void App::SetArguments(AppArguments&& arguments)
{
    _arguments = std::move(arguments);
}

void App::SetConfigurator(std::unique_ptr<IAppConfigurator>&& configurator)
{
    _configurator = std::move(configurator);
}

// void App::Run()
// {
//     if (!_delegate)
//     {
//         return;
//     }
//
//     Setup();
//     _delegate->OnAppRun();
//     //_loop.Run();
//     Teardown();
// }

// void App::Setup()
// {
//     _delegate->OnAppSetup();
// }
//
// void App::Teardown()
// {
//     _delegate->OnAppTeardown();
// }

} // namespace Babylon::System
