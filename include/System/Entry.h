#pragma once

#include <Common/Globals.h>
#include <System/Core.h>
#include <System/IConfigurator.h>

#ifndef BABYLON_ENTRY_POINT

// TODO: return global static error handler result

/****************************************************************************
 * Entry point to app
 * [ConfiguratorClassName] - Babylon::System::IConfigurator based class name
 */
#define BABYLON_ENTRY_POINT(ConfiguratorClassName)           \
int main(int argc, char** argv)                              \
{                                                            \
    Babylon::System::Core::Execute<ConfiguratorClassName>(); \
    return 0;                                                \
}

#endif // BABYLON_ENTRY_POINT
