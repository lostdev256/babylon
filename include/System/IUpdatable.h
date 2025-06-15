#pragma once

namespace BN::System
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
    virtual void Update(double dt) = 0;
};

} // namespace BN::System
