#pragma once

namespace Babylon::System
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

} // namespace Babylon::System
