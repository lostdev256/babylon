#pragma once

namespace babylon::common
{
/**
 * Финализатор для babylon::common::singleton
 * @tparam T Класс-наследник шаблона babylon::common::singleton
 */
template<class T>
class singleton_finalizer final
{
public:
    singleton_finalizer()
    {
        T::create_instance();
    }

    ~singleton_finalizer()
    {
        T::destroy_instance();
    }

    singleton_finalizer(const singleton_finalizer& other) = delete;
    singleton_finalizer& operator=(const singleton_finalizer& other) = delete;
    singleton_finalizer(singleton_finalizer&& other) = delete;
    singleton_finalizer& operator=(singleton_finalizer&& other) = delete;
};

/**
 * Шаблон синглтона
 * @tparam T Класс-наследник данного шаблона
 */
template<class T>
class singleton
{
public:
    using finalizer = singleton_finalizer<T>;

    static T& instance()
    {
        create_instance();
        return *_instance_;
    }

protected:
    static void create_instance()
    {
        if (!_instance_)
        {
            _instance_ = new T();
        }
    }

    static void destroy_instance()
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
T* singleton<T>::_instance_ = nullptr;

} // namespace babylon::common

#ifndef SINGLETON_CLASS
/**
 * Макрос необходимо использовать в связке с наследованием от babylon::common::singleton
 * @tparam self_name Имя класса-наследника babylon::common::singleton
 */
#define SINGLETON_CLASS(self_name)                                  \
                                                                    \
public:                                                             \
    self_name(const self_name& other) = delete;                     \
    self_name(self_name&& other) = delete;                          \
    self_name& operator=(const self_name& other) = delete;          \
    self_name& operator=(self_name&& other) = delete;               \
                                                                    \
private:                                                            \
    self_name() = default;                                          \
    ~self_name() = default;                                         \
                                                                    \
    friend class babylon::common::singleton<self_name>;             \
    friend class babylon::common::singleton_finalizer<self_name>;

#endif // SINGLETON_CLASS
