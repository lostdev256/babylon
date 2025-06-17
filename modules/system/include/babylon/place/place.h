#pragma once

#include <babylon/place/place_node.h>

namespace babylon::place
{

/**
 * Класс базового узла размещения
 */
class place;
using place_ptr = std::shared_ptr<place>;

class place : public place_node
{
public:
    static place_ptr create_impl();
};

} // namespace babylon::place
