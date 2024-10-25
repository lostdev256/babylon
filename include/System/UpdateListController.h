#pragma once

#include <System/IAppLoopController.h>

#include <vector>

namespace Babylon::System
{

/**
 * Класс управления основным циклом приложения
 */
class UpdateListController final : public IAppLoopController
{
public:
    /**
     * Запускает основной цикл
     */
    void Run() override;

private:
    std::vector<IAppLoopControllerPtr> _controllers;
};

} // namespace Babylon::System
