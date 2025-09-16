import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/services/notification_service.dart';
import 'package:task_manager_project/services/shared_pref_service.dart';

final notiSwitcherProvider =
    StateNotifierProvider<NotiSwitcherStateNotifier, bool>((ref) {
      return NotiSwitcherStateNotifier();
    });

class NotiSwitcherStateNotifier extends StateNotifier<bool> {
  NotiSwitcherStateNotifier() : super(true);
  final notification = NotificationService();

Future<void> load()async{

var isSwitchOn=await SharedPrefService.getBool(SharedPrefService.notificationSwitchKEY);

if (isSwitchOn) {
  state=true;
}else{
  state= false;
}

}


  Future<void> onChanged(bool value) async {
    state = value;

    if (value ) {

      notification.scheduleNotification(
        id: DateTime.now().microsecond,
        title: 'Notification enabled',
        body: "You're all set! We'll keep you updated with notifications.",
        hour: DateTime.now().hour,
        sec: DateTime.now().second + 1,
        min: DateTime.now().minute,
        priority: 'High',
      );

       SharedPrefService.setBool(SharedPrefService.notificationSwitchKEY, value);
    } else {
      notification.showNotification(
        title: 'Notification disabled',
        body:
            "Notifications have been turned off. You will no longer receive alerts.",
      );
     await notification.notification.cancelAll();
     SharedPrefService.setBool(SharedPrefService.notificationSwitchKEY, value);
    }
  }
}
