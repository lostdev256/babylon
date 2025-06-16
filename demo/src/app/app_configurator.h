#pragma once

#include <System/IAppConfigurator.h>

namespace App
{

class app_configurator final : public babylon::System::IAppConfigurator
{
public:
    void Configure() override;
};

} // namespace App
