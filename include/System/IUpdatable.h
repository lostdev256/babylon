#pragma once

namespace Babylon::System
{

/**
 * Интерфейс предоставляющий методы обновления.
 */
class IUpdatable
{
public:
    virtual ~IUpdatable() = default;

    /**
     * Метод обновления
     * @param dt Дельта времени прошедшего с предыдущего обновления
     */
    virtual void Update(float dt) = 0;
};

} // namespace Babylon::System
