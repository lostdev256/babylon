#pragma once

#include <memory>

namespace babylon::place
{

class place;
using place_ptr = std::shared_ptr<place>;
using place_wptr = std::weak_ptr<place>;

/**
 * Класс, представляющий place (окно приложения)
 */
class place
{
public:
    virtual ~place() = default;
};

} // namespace babylon::place
