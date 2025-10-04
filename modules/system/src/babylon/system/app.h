#pragma once

#include <babylon/system/app_arguments.h>
#include <babylon/system/app_configurator_iface.h>

#include <memory>

namespace babylon::system
{

/**
 * Класс приложения Babylon
 */
class app
{
public:
    /**
     * Инстанс приложения
     * @return Инстанс приложения под заданную платформу
     */
    static app& instance();

    /**
     * Точка входа в приложение
     * @tparam TConfigurator Класс реализующий babylon::system::app_configurator_iface
     * @param args Аргументы командной строки
     * @return 0 или код ошибки
     */
    template <class TConfigurator>
    static int entry(app_arguments&& args);

protected:
    app() = default;
    virtual ~app() = default;

public:
    app(const app& other) = delete;
    app(app&& other) = delete;
    app& operator=(const app& other) = delete;
    app& operator=(app&& other) = delete;

protected:
    virtual bool init_impl() = 0;
    virtual void run_impl() = 0;

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
    void run();

protected:
    app_arguments _arguments;
    app_configurator_iface_ptr _configurator;
};

template <class TConfigurator>
int app::entry(app_arguments&& args)
{
    static_assert(std::is_base_of_v<app_configurator_iface, TConfigurator>);
    auto configurator = std::make_unique<TConfigurator>();

    auto& app = instance();
    if (!app.init(std::move(args), std::move(configurator)))
    {
        return -1;
    }

    app.run();

    return 0;
}

} // namespace babylon::system
