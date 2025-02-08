#pragma once

namespace Babylon::System
{

class AppArguments
{
public:
    AppArguments() = default;
    AppArguments(int argc, char** argv);

private:
    void Parse();

    std::vector<std::string> _raw_arguments;
    std::map<std::string, std::string> _arguments;
};

} // namespace Babylon::System
