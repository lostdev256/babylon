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
    virtual ~IAppController() = default;

    /**
     * Передача полного контроля за приложением системе. Реализуется конкретной платформой
     */
    virtual void Control() = 0;
};

} // namespace BN::System
