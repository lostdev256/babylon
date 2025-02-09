#pragma once

#include <Platform/Main.h>

/**
 * Точка входа в приложение
 * @tparam TAppConfigurator Имя класса реализующего BN::System::IAppConfigurator
 */
#define BN_ENTRY_POINT(TAppConfigurator) BN_ENTRY_POINT_IMPL(TAppConfigurator)
