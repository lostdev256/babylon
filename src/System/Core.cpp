#include <Core/Core.h>

namespace BS::Core
{

App Core::_app = App();

const App& Core::AppInstance()
{
    return _app;
}

} // namespace BS::Core
