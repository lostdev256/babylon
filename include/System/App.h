#pragma once

#include <Common/Singleton.h>
#include <System/AppArguments.h>
#include <System/IAppConfigurator.h>
#include <Platform/Entry.h>
#include <Platform/IPlatformContext.h>

namespace BN::System
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
     * @tparam TAppConfigurator Класс наследник BN::System::IAppConfigurator
     * @param args Аргументы командной строки
     */
    template<class TAppConfigurator>
    static void Entry(AppArguments&& args);

    /**
     * Метод получения контекста платформы
     * @tparam TPlatformContext Класс наследник Platform::IPlatformContext
     * @return Контекст платформы
     */
    template<class TPlatformContext>
    std::shared_ptr<TPlatformContext> GetPlatformContext();

private:
    /**
     * Выполняет инициализацию приложения
     */
    void Init(AppArguments&& args, IAppConfiguratorPtr&& configurator);

    AppArguments _arguments;
    IAppConfiguratorPtr _configurator;
    Platform::IPlatformContextPtr _platform_context;
};

template <class TAppConfigurator>
void App::Entry(AppArguments&& args)
{
    static_assert(std::is_base_of_v<IAppConfigurator, TAppConfigurator>);
    auto configurator = std::make_unique<TAppConfigurator>();

    Finaliser guard;
    auto& app = Instance();
    app.Init(std::move(args), std::move(configurator));

    Platform::Entry();
}

template<class TPlatformContext>
std::shared_ptr<TPlatformContext> App::GetPlatformContext()
{
    static_assert(std::is_base_of_v<Platform::IPlatformContext, TPlatformContext>);
    return std::dynamic_pointer_cast<TPlatformContext>(_platform_context);
}

} // namespace BN::System
