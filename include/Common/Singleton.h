#pragma once

namespace Babylon::Common
{

template<class T>
class SingletonFinalizer final
{
public:
    SingletonFinalizer()
    {
        T::CreateInstance();
    }

    ~SingletonFinalizer()
    {
        T::DestroyInstance();
    }

    SingletonFinalizer(const SingletonFinalizer& other) = delete;
    SingletonFinalizer& operator=(const SingletonFinalizer& other) = delete;
    SingletonFinalizer(SingletonFinalizer&& other) = delete;
    SingletonFinalizer& operator=(SingletonFinalizer&& other) = delete;
};

template<class T>
class Singleton
{
public:
    using Finaliser = SingletonFinalizer<T>;

    static T& Instance()
    {
        CreateInstance();
        return *__instance;
    }

protected:
    static void CreateInstance()
    {
        if (!__instance)
        {
            __instance = new T();
        }
    }

    static void DestroyInstance()
    {
        if (__instance)
        {
            delete __instance;
            __instance = nullptr;
        }
    }

private:
    static T* __instance;
};

template<class T>
T* Singleton<T>::__instance = nullptr;

} // namespace Babylon::Common

#ifndef SINGLETON_CLASS
/**
 * TODO: add description
 */
#define SINGLETON_CLASS(ClassName)                                  \
                                                                    \
public:                                                             \
    ClassName(const ClassName& other) = delete;                     \
    ClassName(ClassName&& other) = delete;                          \
    ClassName& operator=(const ClassName& other) = delete;          \
    ClassName& operator=(ClassName&& other) = delete;               \
                                                                    \
private:                                                            \
    ClassName() = default;                                          \
    ~ClassName() = default;                                         \
                                                                    \
    friend class Babylon::Common::Singleton<ClassName>;             \
    friend class Babylon::Common::SingletonFinalizer<ClassName>;

#endif // SINGLETON_CLASS
