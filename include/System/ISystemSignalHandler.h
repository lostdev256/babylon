#pragma once

namespace BN::System
{

/**
 * Интерфейс обработчика системных сигналов.
 */
class ISystemSignalHandler
{
public:
    virtual ~ISystemSignalHandler() = default;
};

} // namespace BN::System
