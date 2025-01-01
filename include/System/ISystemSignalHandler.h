#pragma once

namespace Babylon::System
{

/**
 * Интерфейс обработчика системных сигналов.
 */
class ISystemSignalHandler
{
public:
    virtual ~ISystemSignalHandler() = default;
};

} // namespace Babylon::System
