#include <pch.h>

#include <System/DrawListController.h>

namespace Babylon::System
{

void DrawListController::Run()
{
    for (const auto& controller : _controllers)
    {
        controller->Run();
    }
}

} // namespace Babylon::System
