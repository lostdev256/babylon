#pragma once

#include <babylon/common/singleton.h>
#include <babylon/system/app_arguments.h>
#include <babylon/system/app_configurator_iface.h>
#include <babylon/system/app_controller_iface.h>

namespace babylon::system
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
     * @tparam TConfigurator Класс реализующий babylon::system::app_configurator_iface
     * @param args Аргументы командной строки
     */
    template<class TConfigurator>
    static void entry(app_arguments&& args);

private:
    /**
     * Выполняет инициализацию приложения
     * @param args Аргументы командной строки
     * @param configurator Конфигуратор приложения
     */
    bool init(app_arguments&& args, app_configurator_iface_ptr&& configurator);

    /**
     * Выполняет запуск основной логики работы приложения
     */
    void run() const;

    app_arguments _arguments;
    app_configurator_iface_ptr _configurator;
    app_controller_iface_ptr _controller;
};

template <class TConfigurator>
void app::entry(app_arguments&& args)
{
    static_assert(std::is_base_of_v<app_configurator_iface, TConfigurator>);
    auto configurator = std::make_unique<TConfigurator>();

    finalizer guard;
    auto& app = instance();
    if (app.init(std::move(args), std::move(configurator)))
    {
        app.run();
    }
}

} // namespace babylon::system
