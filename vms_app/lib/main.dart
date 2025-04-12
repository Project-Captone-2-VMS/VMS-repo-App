import 'package:vms_app/bootstrap.dart';
import 'package:vms_app/di/injection_container.dart';
import 'app.dart';

Future<void> main() async {
  await bootstrap(() async {
    await ProductionServiceLocator().setup();
    return const MyApp();
  });
}
