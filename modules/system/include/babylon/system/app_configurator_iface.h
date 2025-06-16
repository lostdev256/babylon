#pragma once

namespace BN::System
{

/**
 * Интерфейс конфигуратора приложения. Обязательно реализуется на стороне клиента.
 */
class app_configurator_iface;
using IAppConfiguratorPtr = std::unique_ptr<app_configurator_iface>;

class app_configurator_iface
{
public:
    virtual ~app_configurator_iface() = default;

    /**
     * Метод должен реализовать стартовую логику приложения (подключить необходимые для старта модули и виджеты)
     */
    virtual void Configure() = 0;
};

} // namespace BN::System
