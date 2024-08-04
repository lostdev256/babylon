#include <System/App.h>

namespace Babylon::System
{

void App::Execute()
{
    if (!_delegate)
    {
        return;
    }

    Init();

    _delegate->Run();

    Loop();
    DeInit();
}

void App::Init()
{
    if (!_delegate)
    {
        return;
    }

    _delegate->Init();
}

void App::DeInit()
{
    if (!_delegate)
    {
        return;
    }

    _delegate->DeInit();
}

void App::Loop()
{
}

} // namespace Babylon::System
