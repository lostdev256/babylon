#pragma once

#include <Place/PlaceNodeView.h>

namespace BN::Place
{

/**
 *
 */
class place_view;
using PlaceViewPtr = std::shared_ptr<place_view>;

class place_view : public PlaceNodeView
{
public:
    static PlaceViewPtr CreateImpl();
};

} // namespace BN::Place
