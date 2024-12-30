#pragma once

#include <Common/Singleton.h>
#include <System/AppArguments.h>
#include <System/IAppConfigurator.h>
#include <Platform/Entry.h>

namespace Babylon::System
{

/**
 * Класс управления приложением
 */
class App final : public Common::Singleton<App>
{
    SINGLETON_CLASS(App)

public:
    /**
     * Точко входа в приложение
     * @tparam TAppConfigurator Имя класса наследника Babylon::System::IAppConfigurator
     * @param args Аргументы командной строки
     */
    template<class TAppConfigurator>
    static void Entry(AppArguments&& args);

    /**
     * Выполняет инициализацию приложения и делегата
     */
    void Init();

    /**
     * Выполняет де инициализацию приложения и делегата
     */
    void Deinit();

    void Update();

    /**
     * Запускает приложение
     */
    void Run();

private:
    void SetArguments(AppArguments&& args);
    void SetConfigurator(std::unique_ptr<IAppConfigurator>&& configurator);

    AppArguments _arguments;
    std::unique_ptr<IAppConfigurator> _configurator;
};

template <class TAppConfigurator>
void App::Entry(AppArguments&& args)
{
    static_assert(std::is_base_of_v<IAppConfigurator, TAppConfigurator>);
    auto configurator = std::make_unique<TAppConfigurator>();

    Finaliser guard;
    auto& app = Instance();
    app.SetArguments(std::move(args));
    app.SetConfigurator(std::move(configurator));

    Platform::Entry();
}

} // namespace Babylon::System
