export module babylon.system:app_configurator_iface;

export namespace babylon::system
{

/**
 * Интерфейс конфигуратора приложения. Обязательно реализуется на стороне клиента.
 */
class app_configurator_iface;
using app_configurator_iface_ptr = std::unique_ptr<app_configurator_iface>;

class app_configurator_iface
{
public:
    virtual ~app_configurator_iface() = default;

    /**
     * Метод должен реализовать стартовую логику приложения (подключить необходимые для старта модули и виджеты)
     */
    virtual void configure() = 0;
};

} // namespace babylon::system
