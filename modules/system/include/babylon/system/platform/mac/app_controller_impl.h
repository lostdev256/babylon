#pragma once

#include <babylon/system/app_controller_iface.h>
#include <babylon/platform/mac/app_delegate.h>

namespace babylon::system::platform
{

class app_controller_impl final : public app_controller_iface
{
public:
    void control() override;

private:
    //app_delegate* _delegate;
};

} // namespace babylon::system::platform
