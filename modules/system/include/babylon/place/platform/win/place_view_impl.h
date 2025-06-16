#pragma once

#include <Place/PlaceView.h>

namespace BN::Place::Platform
{

/**
 *
 */
class place_view_impl final : public PlaceView
{
public:
    bool Create() override;
};

} // namespace BN::Place::Platform
