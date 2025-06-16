#pragma once

#include <Place/PlaceView.h>

namespace babylon::Place::Platform
{

/**
 *
 */
class place_view_impl final : public PlaceView
{
public:
    bool Create() override;
};

} // namespace babylon::Place::Platform
