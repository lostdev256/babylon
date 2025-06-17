#pragma once

#include <babylon/place/place_view.h>

namespace babylon::place::platform
{

/**
 *
 */
class place_view_impl final : public place_view
{
public:
    bool create() override;
};

} // namespace babylon::place::platform
