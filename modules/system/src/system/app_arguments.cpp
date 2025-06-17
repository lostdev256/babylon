#include <pch.h>

#include <babylon/system/app_arguments.h>

namespace babylon::system
{

app_arguments::app_arguments(int argc, char** argv)
{
    for (int i = 0; i < argc; ++i)
    {
        _raw_arguments.emplace_back(argv[i]);
    }

    parse();
}

void app_arguments::parse()
{
    // TODO: Implement
}

} // namespace babylon::system
