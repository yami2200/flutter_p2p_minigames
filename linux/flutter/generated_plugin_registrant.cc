//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_p2p_plus/flutter_p2p_plus_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_p2p_plus_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterP2pPlusPlugin");
  flutter_p2p_plus_plugin_register_with_registrar(flutter_p2p_plus_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
