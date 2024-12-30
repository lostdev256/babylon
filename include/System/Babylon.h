#pragma once

#include <Platform/Main.h>

/**
 * Точка входа в приложение
 * @tparam TAppConfigurator Имя класса реализующего Babylon::System::IAppConfigurator
 */
#define BABYLON_ENTRY_POINT(TAppConfigurator) BABYLON_ENTRY_POINT_IMPL(TAppConfigurator)
