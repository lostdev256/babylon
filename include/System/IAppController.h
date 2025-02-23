#pragma once

namespace BN::System
{

/**
 * Интерфейс системного контроллера приложения.
 */
class IAppController;
using IAppControllerPtr = std::shared_ptr<IAppController>;

class IAppController
{
public:
    /**
     * Создание платформа-зависимого экземпляра класса. Реализуется конкретной платформой
     * @return Указатель на интерфейс
     */
    static IAppControllerPtr Create();

public:
    virtual ~IAppController() = default;

    /**
     * Передача полного контроля за приложением системе. Реализуется конкретной платформой
     */
    virtual void Control() = 0;
};

} // namespace BN::System
