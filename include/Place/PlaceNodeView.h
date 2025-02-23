#pragma once

namespace BN::Place
{

/**
 *
 */
class PlaceNodeView
{
public:
    PlaceNodeView() = default;
    virtual ~PlaceNodeView() = default;

    virtual bool Create() = 0;
};

} // namespace BN::Place
