#pragma once

namespace BN::System
{

/**
 * Интерфейс предоставляющий методы отрисовки.
 */
class IDrawable
{
public:
    virtual ~IDrawable() = default;

    /**
     * Метод отрисовки
     */
    virtual void Draw() = 0;
};

} // namespace BN::System
