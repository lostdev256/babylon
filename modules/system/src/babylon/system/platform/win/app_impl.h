#pragma once

#include <babylon/system/app.h>

namespace babylon::system::platform
{

class app_impl final : public app
{
protected:
    bool init_impl() override;
    void run_impl() override;
};

} // namespace babylon::system::platform
