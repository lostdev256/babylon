#pragma once

namespace BN::Common
{
/**
 * Финализатор для BN::Common::Singleton
 * @tparam T Класс-наследник шаблона BN::Common::Singleton
 */
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

/**
 * Шаблон синглтона
 * @tparam T Класс-наследник данного шаблона
 */
template<class T>
class Singleton
{
public:
    using Finalizer = SingletonFinalizer<T>;

    static T& Instance()
    {
        CreateInstance();
        return *_instance_;
    }

protected:
    static void CreateInstance()
    {
        if (!_instance_)
        {
            _instance_ = new T();
        }
    }

    static void DestroyInstance()
    {
        if (_instance_)
        {
            delete _instance_;
            _instance_ = nullptr;
        }
    }

private:
    static T* _instance_;
};

template<class T>
T* Singleton<T>::_instance_ = nullptr;

} // namespace BN::Common

#ifndef SINGLETON_CLASS
/**
 * Макрос необходимо использовать в связке с наследованием от BN::Common::Singleton
 * @tparam ClassName Имя класса-наследника BN::Common::Singleton
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
    friend class BN::Common::Singleton<ClassName>;                  \
    friend class BN::Common::SingletonFinalizer<ClassName>;

#endif // SINGLETON_CLASS
