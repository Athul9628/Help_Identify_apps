import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
class Appinform extends StatefulWidget {
  final Application app ;


  Appinform({Key key,this.app}):super(key:key);

  @override
  _AppinformState createState() => _AppinformState();
}

class _AppinformState extends State<Appinform> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Card(
        color:Theme.of(context).colorScheme.primary ,
          elevation: 0,
        child: ListTile(

          leading: widget.app is ApplicationWithIcon
              ? CircleAvatar(
//            backgroundImage: MemoryImage(widget.app.icon),
//              backgroundColor: Colors.white,
          )
              : null,
          onTap: () => DeviceApps.openApp(widget.app.packageName),
          title: Text("${widget.app.appName} (${widget.app.packageName})",
              style: Theme.of(context).textTheme.body1),
          subtitle: Text('Version: ${widget.app.versionName}\n'
              'System app: ${widget.app.systemApp}\n'
              'APK file path: ${widget.app.apkFilePath}\n'
              'Data dir : ${widget.app.dataDir}\n'
              'Installed: ${DateTime.fromMillisecondsSinceEpoch(widget.app.installTimeMilis).toString()}\n'
              'Updated: ${DateTime.fromMillisecondsSinceEpoch(widget.app.updateTimeMilis).toString()}',
              style: Theme.of(context).textTheme.body2),
        ),
      ),
    );
  }
}
