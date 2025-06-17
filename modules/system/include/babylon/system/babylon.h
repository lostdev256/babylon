#pragma once

#include <babylon/platform/main.h>

/**
 * Точка входа в приложение
 * @tparam TConfigurator Класс реализующий babylon::system::app_configurator_iface
 */
#define BABYLON_ENTRY_POINT(TConfigurator) BABYLON_ENTRY_POINT_IMPL(TConfigurator)
