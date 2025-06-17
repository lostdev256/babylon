#include <pch.h>

#include <babylon/system/app.h>

#include <babylon/platform/platform.h>

namespace babylon::system
{

bool app::init(app_arguments&& args, app_configurator_iface_ptr&& configurator)
{
    _arguments = std::move(args);
    _configurator = std::move(configurator);
    _controller = app_controller_iface::create_impl();

    if (!_controller)
    {
        return false;
    }

    return true;
}

void app::run() const
{
    _controller->control();
}

} // namespace babylon::system
