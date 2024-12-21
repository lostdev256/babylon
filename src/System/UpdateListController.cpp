#include <pch.h>

#include <System/UpdateListController.h>

namespace Babylon::System
{

void UpdateListController::Run()
{
    for (const auto& controller : _controllers)
    {
        controller->Run();
    }
}

} // namespace Babylon::System
