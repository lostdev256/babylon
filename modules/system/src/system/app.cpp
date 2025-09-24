#include <babylon/system/app.h>
#include <memory>

namespace babylon::system
{

bool app::init(app_arguments&& args, app_configurator_iface_ptr&& configurator)
{
    _arguments = std::move(args);
    _configurator = std::move(configurator);
    _impl = std::make_shared<platform::app_impl>();

    if (!_impl)
    {
        return false;
    }

    return true;
}

void app::run()
{
    _impl->run();
}

} // namespace babylon::system
