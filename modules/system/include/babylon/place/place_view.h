#pragma once

#include <babylon/place/place_node_view.h>

namespace babylon::place
{

/**
 *
 */
class place_view;
using place_view_ptr = std::shared_ptr<place_view>;

class place_view : public place_node_view
{
public:
    static place_view_ptr create_impl();
};

} // namespace babylon::place
