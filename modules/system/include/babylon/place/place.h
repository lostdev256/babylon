#pragma once

#include <Place/PlaceNode.h>

namespace BN::Place
{

/**
 * Класс базового узла размещения
 */
class place;
using PlacePtr = std::shared_ptr<place>;

class place : public PlaceNode
{
public:
    static PlacePtr CreateImpl();
};

} // namespace BN::Place
