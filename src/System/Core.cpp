#include <System/Core.h>

namespace Babylon::System
{

App Core::_app = App();

const App& Core::AppInstance()
{
    return _app;
}

} // namespace Babylon::System
