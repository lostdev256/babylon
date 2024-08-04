#pragma once

#include <Common/Singleton.h>
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
    void Execute();

private:
    /**
     * Выполняет инициализацию приложения и делегата
     */
    void Init();

    /**
     * Выполняет де инициализацию приложения и делегата
     */
    void DeInit();

    /**
     * Запускает основной цикл
     */
    void Loop();

private:
    IAppDelegateUPtr _delegate;
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
