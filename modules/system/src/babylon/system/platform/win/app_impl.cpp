#include <babylon/system/platform/win/app_impl.h>

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>

namespace babylon::system::platform
{

bool app_impl::init_impl()
{
    return true;
}

void app_impl::run_impl()
{
}

} // namespace babylon::system::platform
