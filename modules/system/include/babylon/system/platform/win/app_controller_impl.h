#pragma once

#include <System/IAppController.h>

namespace BN::System::Platform
{

class app_controller_impl final : public IAppController
{
public:
    void Control() override;
};

} // namespace BN::System::Platform
