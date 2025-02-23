#pragma once

#include <Place/PlaceNode.h>

namespace BN::Place
{

/**
 * Класс базового узла размещения
 */
class Place;
using PlacePtr = std::shared_ptr<Place>;

class Place : public PlaceNode
{
public:
    static PlacePtr CreateImpl();
};

} // namespace BN::Place
