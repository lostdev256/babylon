#include <System/App.h>

namespace Babylon::System
{

void App::Run()
{
    if (!_delegate)
    {
        return;
    }

    Setup();
    _delegate->OnAppRun();
    _loop.Run();
    Teardown();
}

void App::Setup()
{
    _delegate->OnAppSetup();
}

void App::Teardown()
{
    _delegate->OnAppTeardown();
}

} // namespace Babylon::System
