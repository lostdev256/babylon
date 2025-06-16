#pragma once

#include <System/IAppController.h>

namespace babylon::System::Platform
{

class app_controller_impl final : public IAppController
{
public:
    void Control() override;
};

} // namespace babylon::System::Platform
