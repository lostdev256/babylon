#pragma once

#include <System/IAppController.h>
#include <Platform/Apple/Mac/AppDelegate.h>

namespace babylon::System::Platform
{

class app_controller_impl final : public IAppController
{
public:
    void Control() override;

private:
    //AppDelegate* _delegate;
};

} // namespace babylon::System::Platform
