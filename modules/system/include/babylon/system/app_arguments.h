#pragma once

namespace babylon::system
{

/**
 * Контейнер для аргументов командной строки.
 */
class app_arguments
{
public:
    app_arguments() = default;
    app_arguments(int argc, char** argv);

private:
    void parse();

    std::vector<std::string> _raw_arguments;
    std::map<std::string, std::string> _arguments;
};

} // namespace babylon::system
