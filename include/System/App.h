#pragma once

#include <Common/Singleton.h>
#include <System/AppLoopController.h>
#include <System/IAppDelegate.h>

#include <memory>

namespace Babylon::System
{

/**
 * Класс управления приложением
 */
class App final : public Babylon::Common::Singleton<App>
{
    SINGLETON_CLASS(App)

public:
    template<class T>
    inline void UseDelegate();

    /**
     * Запускает приложение
     */
    void Run();

private:
    /**
     * Выполняет инициализацию приложения и делегата
     */
    void Setup();

    /**
     * Выполняет де инициализацию приложения и делегата
     */
    void Teardown();

private:
    IAppDelegateUPtr _delegate;
    AppLoopController _loop;
};

template<class T>
inline void App::UseDelegate()
{
    // try
    {
        _delegate = std::make_unique<T>();
    }
    // catch (const std::exception&)
    {
        // TODO: crash report
        // return false;
    }
}

} // namespace Babylon::System
