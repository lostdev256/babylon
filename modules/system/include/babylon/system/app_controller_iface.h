#pragma once

namespace babylon::system
{

/**
 * Интерфейс системного контроллера приложения.
 */
class app_controller_iface;
using app_controller_iface_ptr = std::shared_ptr<app_controller_iface>;

class app_controller_iface
{
public:
    /**
     * Создание платформа-зависимого экземпляра класса. Реализуется конкретной платформой
     * @return Указатель на интерфейс
     */
    static app_controller_iface_ptr create_impl();

public:
    virtual ~app_controller_iface() = default;

    /**
     * Передача полного контроля за приложением системе. Реализуется конкретной платформой
     */
    virtual void control() = 0;
};

} // namespace babylon::system
