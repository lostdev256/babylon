#pragma once

#include <babylon/platform/mac/app_delegate.h>
#include <babylon/system/app_controller_iface.h>

namespace babylon::system::platform
{

class app_controller_impl final : public app_controller_iface
{
public:
    void control() override;

private:
    // app_delegate* _delegate;
};

} // namespace babylon::system::platform
