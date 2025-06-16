#pragma once

namespace BN::System
{

/**
 * Интерфейс обработчика системных сигналов.
 */
class system_signal_handler_iface
{
public:
    virtual ~system_signal_handler_iface() = default;
};

} // namespace BN::System
