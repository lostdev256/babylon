#pragma once

#include <System/IAppConfigurator.h>

namespace App
{

class app_configurator final : public BN::System::IAppConfigurator
{
public:
    void Configure() override;
};

} // namespace App
