#include <babylon/system/app.h>
#include <babylon/system/platform/app_impl.h>

namespace babylon::system
{

app& app::instance()
{
    static platform::app_impl _instance{};
    return _instance;
}

bool app::init(app_arguments&& args, app_configurator_iface_ptr&& configurator)
{
    _arguments = std::move(args);
    _configurator = std::move(configurator);
    return init_impl();
}

void app::run()
{
    run_impl();
}

} // namespace babylon::system
