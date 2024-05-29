#pragma once

#include <Common/Globals.h>
#include <System/App.h>

namespace Babylon::System
{

class Core final
{
public:
    static const App& AppInstance();

    template<class T>
    static bool Execute();

private:
    Core() = delete;
    Core(const Core&) = delete;
    Core(Core&&) = delete;
    Core& operator=(const Core&) = delete;
    Core& operator=(Core&&) = delete;

    static App _app;
};

template<class T>
inline bool Core::Core::Execute()
{
    // try
    {
//        _app.SetDelegate(std::make_unique<T>());
//
//        if (!_app.Init())
//        {
//            return false;
//        }

        auto result = _app.Execute();

//        _app.Deinit();

        return result;
    }
    // catch (const std::exception&)
    {
        // TODO: crash report
        // return false;
    }
}

} // namespace Babylon::System
