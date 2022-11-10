import 'package:event_bus/event_bus.dart';
import 'package:wanma_print/common/event/http_error_event.dart';

import '../event/scan_event.dart';

class ScanEventUtils {

  static final EventBus eventBus = EventBus();

  static send(var page, var scanResult) {
    //发送
    eventBus.fire(ScanEvent(page, scanResult));
  }
}
