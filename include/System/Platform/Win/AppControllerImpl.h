#pragma once

#include <System/IAppController.h>

namespace BN::System::Platform
{

class AppControllerImpl final : public IAppController
{
public:
    void Control() override;
};

} // namespace BN::System::Platform
