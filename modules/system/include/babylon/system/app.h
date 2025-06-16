#pragma once

#include <Common/Singleton.h>
#include <System/AppArguments.h>
#include <System/IAppConfigurator.h>
#include <System/IAppController.h>

namespace babylon::System
{

/**
 * Класс приложения Babylon
 */
class app final : public common::singleton<app>
{
    SINGLETON_CLASS(app)

public:
    /**
     * Точко входа в приложение
     * @tparam TAppConfigurator Класс реализующий babylon::System::IAppConfigurator
     * @param args Аргументы командной строки
     */
    template<class TAppConfigurator>
    static void Entry(AppArguments&& args);

private:
    /**
     * Выполняет инициализацию приложения
     * @param args Аргументы командной строки
     * @param configurator Конфигуратор приложения
     */
    bool Init(AppArguments&& args, IAppConfiguratorPtr&& configurator);

    /**
     * Выполняет запуск основной логики работы приложения
     */
    void Run() const;

    AppArguments _arguments;
    IAppConfiguratorPtr _configurator;
    IAppControllerPtr _controller;
};

template <class TAppConfigurator>
void app::Entry(AppArguments&& args)
{
    static_assert(std::is_base_of_v<IAppConfigurator, TAppConfigurator>);
    auto configurator = std::make_unique<TAppConfigurator>();

    finalizer guard;
    auto& app = Instance();
    if (app.Init(std::move(args), std::move(configurator)))
    {
        app.Run();
    }
}

} // namespace babylon::System
