#pragma once

#include <Common/Singleton.h>
#include <System/AppArguments.h>
#include <System/IAppDelegate.h>

namespace Babylon::System
{

/**
 * Класс управления приложением
 */
class App final : public Common::Singleton<App>
{
    SINGLETON_CLASS(App)

public:
    void SetArguments(AppArguments&& arguments);
    void SetDelegate(IAppDelegateUPtr&& delegate);

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

//private:




private:
    AppArguments _arguments;
    IAppDelegateUPtr _delegate;
    //AppLoopController _loop;
};

} // namespace Babylon::System
