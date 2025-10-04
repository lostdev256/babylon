#pragma once

#include <memory>

namespace babylon::place
{

class place_view;
using place_view_ptr = std::shared_ptr<place_view>;
using place_view_wptr = std::weak_ptr<place_view>;

/**
 *
 */
class place_view
{
public:
    virtual ~place_view() = default;
};

} // namespace babylon::place
