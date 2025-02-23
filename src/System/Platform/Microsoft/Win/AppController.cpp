#include <pch.h>

#include <System/Platform/Microsoft/Win/AppController.h>

namespace BN::System
{

    IAppControllerPtr IAppController::Create()
    {
        return std::make_shared<Platform::AppController>();
    }

} // namespace BN::System

namespace BN::System::Platform
{

void AppController::Control()
{
}

} // namespace BN::System::Platform
