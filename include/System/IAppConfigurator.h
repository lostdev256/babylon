#pragma once

namespace Babylon::System
{

/**
 * Интерфейс конфигуратора приложения. Обязательно реализуется на стороне клиента.
 */
class IAppConfigurator;
using IAppConfiguratorPtr = std::unique_ptr<IAppConfigurator>;

class IAppConfigurator
{
public:
    virtual ~IAppConfigurator() = default;

    /**
     * Метод должен реализовать стартовую логику приложения (подключить необходимые для старта модули и виджеты)
     */
    virtual void Configure() = 0;
};

} // namespace Babylon::System
