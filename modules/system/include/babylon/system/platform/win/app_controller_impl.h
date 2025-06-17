#pragma once

#include <babylon/system/app_controller_iface.h>

namespace babylon::system::platform
{

class app_controller_impl final : public app_controller_iface
{
public:
    void control() override;
};

} // namespace babylon::system::platform
