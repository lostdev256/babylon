#pragma once

namespace babylon::place
{

/**
 *
 */
class place_node_view
{
public:
    place_node_view() = default;
    virtual ~place_node_view() = default;

    virtual bool create() = 0;
};

} // namespace babylon::place
