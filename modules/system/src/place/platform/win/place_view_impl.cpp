#include <babylon/place/platform/win/place_view_impl.h>

namespace babylon::place
{

place_view_ptr place_view::create_impl()
{
    return std::make_shared<platform::place_view_impl>();
}

} // namespace babylon::place

namespace babylon::place::platform
{

bool place_view_impl::create()
{
    return true;
}

} // namespace babylon::place::platform
