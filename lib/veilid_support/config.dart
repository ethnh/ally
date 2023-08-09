import 'package:charcode/charcode.dart';
import 'package:veilid/veilid.dart';

Future<VeilidConfig> getVeilidChatConfig() async {
  var config = await getDefaultVeilidConfig('VeilidChat');
  // ignore: do_not_use_environment
  if (const String.fromEnvironment('DELETE_TABLE_STORE') == '1') {
    config =
        config.copyWith(tableStore: config.tableStore.copyWith(delete: true));
  }
  // ignore: do_not_use_environment
  if (const String.fromEnvironment('DELETE_PROTECTED_STORE') == '1') {
    config = config.copyWith(
        protectedStore: config.protectedStore.copyWith(delete: true));
  }
  // ignore: do_not_use_environment
  if (const String.fromEnvironment('DELETE_BLOCK_STORE') == '1') {
    config =
        config.copyWith(blockStore: config.blockStore.copyWith(delete: true));
  }

  // xxx hack
  config = config.copyWith(
      network: config.network.copyWith(
          dht: config.network.dht.copyWith(
              getValueCount: 2,
              getValueTimeoutMs: 5000,
              setValueCount: 2,
              setValueTimeoutMs: 5000)));

  return config;
}
