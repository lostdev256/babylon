#include <pch.h>

#include <System/AppArguments.h>

namespace BN::System
{

AppArguments::AppArguments(int argc, char** argv)
{
    for (int i = 0; i < argc; ++i)
    {
        _raw_arguments.emplace_back(argv[i]);
    }

    Parse();
}

void AppArguments::Parse()
{
    // TODO: Implement
}

} // namespace BN::System
