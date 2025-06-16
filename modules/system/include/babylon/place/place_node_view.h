#pragma once

namespace BN::Place
{

/**
 *
 */
class place_node_view
{
public:
    place_node_view() = default;
    virtual ~place_node_view() = default;

    virtual bool Create() = 0;
};

} // namespace BN::Place
