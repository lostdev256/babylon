#pragma once

#include <Place/PlaceView.h>

namespace BN::Place::Platform
{

/**
 *
 */
class PlaceViewImpl final : public PlaceView
{
public:
    bool Create() override;
};

} // namespace BN::Place::Platform
