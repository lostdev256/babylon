#pragma once

namespace BN::System
{

/**
 * Интерфейс предоставляющий методы отрисовки.
 */
class drawable_iface
{
public:
    virtual ~drawable_iface() = default;

    /**
     * Метод отрисовки
     */
    virtual void Draw() = 0;
};

} // namespace BN::System
