#pragma once

#include <System/IAppController.h>

namespace BN::Platform::Apple::Mac
{

class AppController final : public System::IAppController
{
    void Control() override;
};

} // namespace BN::Platform::Apple::Mac
