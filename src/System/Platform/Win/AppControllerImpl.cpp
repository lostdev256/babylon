#include <pch.h>

#include <System/Platform/Win/AppControllerImpl.h>

namespace BN::System
{

    IAppControllerPtr IAppController::CreateImpl()
    {
        return std::make_shared<Platform::AppControllerImpl>();
    }

} // namespace BN::System

namespace BN::System::Platform
{

void AppControllerImpl::Control()
{
}

} // namespace BN::System::Platform
