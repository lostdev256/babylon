#pragma once

#include <Common/Globals.h>
#include <System/IAppDelegate.h>

namespace Babylon::System
{

class App final
{
public:
    void SetDelegate(IAppDelegateUPtr delegate);

    bool Init();
    void Deinit();
    bool Run();

private:
    IAppDelegateUPtr _delegate;
};

} // namespace Babylon::System
