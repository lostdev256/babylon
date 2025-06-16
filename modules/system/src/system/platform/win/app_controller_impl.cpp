#include <pch.h>

#include <System/Platform/Win/AppControllerImpl.h>

namespace babylon::System
{

    IAppControllerPtr IAppController::CreateImpl()
    {
        return std::make_shared<Platform::AppControllerImpl>();
    }

} // namespace babylon::System

namespace babylon::System::Platform
{

void AppControllerImpl::Control()
{
}

} // namespace babylon::System::Platform
