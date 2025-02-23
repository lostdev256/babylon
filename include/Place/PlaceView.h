#pragma once

#include <Place/PlaceNodeView.h>

namespace BN::Place
{

/**
 *
 */
class PlaceView;
using PlaceViewPtr = std::shared_ptr<PlaceView>;

class PlaceView : public PlaceNodeView
{
public:
    static PlaceViewPtr CreateImpl();
};

} // namespace BN::Place
