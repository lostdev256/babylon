#pragma once

namespace babylon::System
{

/**
 * Интерфейс системного контроллера приложения.
 */
class app_controller_iface;
using IAppControllerPtr = std::shared_ptr<app_controller_iface>;

class app_controller_iface
{
public:
    /**
     * Создание платформа-зависимого экземпляра класса. Реализуется конкретной платформой
     * @return Указатель на интерфейс
     */
    static IAppControllerPtr CreateImpl();

public:
    virtual ~app_controller_iface() = default;

    /**
     * Передача полного контроля за приложением системе. Реализуется конкретной платформой
     */
    virtual void Control() = 0;
};

} // namespace babylon::System
