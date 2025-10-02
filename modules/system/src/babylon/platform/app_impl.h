#pragma once

#include <memory>

namespace babylon::platform
{

class app_impl;
using app_impl_ptr = std::shared_ptr<app_impl>;

class app_impl
{
public:
    void run();
};

} // namespace babylon::platform
