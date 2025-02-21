#include <pch.h>

#include <Platform/Platform.h>

#include <Platform/Apple/Mac/AppController.h>

namespace BN::Platform
{

System::IAppControllerPtr CreateAppController()
{
    return std::make_shared<Apple::Mac::AppController>();
}

} // namespace BN::Platform
