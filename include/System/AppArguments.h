#pragma once

namespace Babylon::System
{

class AppArguments
{
public:
    AppArguments() = default;
    AppArguments(int argc, char** argv);

private:
    void Parse(int argc, char** argv);

    std::map<std::string, std::string> _arguments;
};

} // namespace Babylon::System
