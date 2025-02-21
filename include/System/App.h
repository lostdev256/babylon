#pragma once

#include <Common/Singleton.h>
#include <System/AppArguments.h>
#include <System/IAppConfigurator.h>
#include <System/IAppController.h>

namespace BN::System
{

/**
 * Класс приложения Babylon
 */
class App final : public Common::Singleton<App>
{
    SINGLETON_CLASS(App)

public:
    /**
     * Точко входа в приложение
     * @tparam TAppConfigurator Класс реализующий BN::System::IAppConfigurator
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
void App::Entry(AppArguments&& args)
{
    static_assert(std::is_base_of_v<IAppConfigurator, TAppConfigurator>);
    auto configurator = std::make_unique<TAppConfigurator>();

    Finalizer guard;
    auto& app = Instance();
    if (app.Init(std::move(args), std::move(configurator)))
    {
        app.Run();
    }
}

} // namespace BN::System
