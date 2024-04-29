#include <System/App.h>

namespace Babylon::System
{

void App::SetDelegate(IAppDelegateUPtr delegate)
{
    _delegate.swap(delegate);
}

bool App::Init()
{
    if (!_delegate)
    {
        return false;
    }

    _delegate->OnInit();

    return true;
}

void App::Deinit()
{
    if (!_delegate)
    {
        return;
    }

    _delegate->OnDeinit();
}

bool App::Run()
{
    if (!_delegate)
    {
        return false;
    }

    _delegate->Run();

    return true;
}

} // namespace Babylon::System
