#include <System/AppLoopController.h>

namespace Babylon::System
{

void AppLoopController::Run()
{
    for (const auto& controller : _controllers)
    {
        controller->Run();
    }
}

} // namespace Babylon::System
