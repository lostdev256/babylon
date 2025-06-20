#pragma once

#include <babylon/system/app_configurator_iface.h>

namespace app
{

class app_configurator final : public babylon::system::app_configurator_iface
{
public:
    void configure() override;
};

} // namespace app
