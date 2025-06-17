#pragma once

#include <babylon/system/app_configurator_iface.h>

namespace App
{

class app_configurator final : public babylon::system::app_configurator_iface
{
public:
    void configure() override;
};

} // namespace App
