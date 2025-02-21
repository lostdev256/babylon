#pragma once

#include <System/IAppController.h>

namespace BN::Platform::Microsoft::Win
{

class AppController final : public System::IAppController
{
    void Control() override;
};

} // namespace BN::Platform::Microsoft::Win
