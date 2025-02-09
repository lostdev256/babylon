#pragma once

#include <System/IAppLoopController.h>

namespace BN::System
{

/**
 * Класс управления основным циклом приложения
 */
class AppLoopController final : public IAppLoopController
{
public:
    /**
     * Запускает основной цикл
     */
    void Run() override;

private:
    std::vector<IAppLoopControllerPtr> _controllers;
};

} // namespace BN::System
