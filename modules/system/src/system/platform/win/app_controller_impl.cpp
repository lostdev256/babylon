#include <babylon/system/platform/win/app_controller_impl.h>

namespace babylon::system
{

app_controller_iface_ptr app_controller_iface::create_impl()
{
    return std::make_shared<platform::app_controller_impl>();
}

} // namespace babylon::system

namespace babylon::system::platform
{

void app_controller_impl::control()
{
}

} // namespace babylon::system::platform
