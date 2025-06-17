#include <pch.h>

#include <babylon/place/platform/mac/place_impl.h>

namespace babylon::place
{

    place_ptr place::create_impl()
    {
        return std::make_shared<platform::place_impl>();
    }

} // namespace babylon::place

namespace babylon::place::platform
{

} // namespace babylon::place::platform
