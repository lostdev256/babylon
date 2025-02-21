#include <pch.h>

#include <Platform/Platform.h>

#include <Platform/Microsoft/Win/AppController.h>

namespace BN::Platform
{

System::IAppControllerPtr CreateAppController()
{
    return std::make_shared<Microsoft::Win::AppController>();
}

} // namespace BN::Platform
