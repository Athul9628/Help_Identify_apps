import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'ads.dart';
import 'package:android_intent/android_intent.dart';
import 'package:removechina/installed_apps.dart';
import 'package:removechina/list.dart';

class chinaapplist extends StatefulWidget {
  @override
  _chinaapplistState createState() => _chinaapplistState();
}

class _chinaapplistState extends State<chinaapplist> {
  bool _showSystemApps = false;
  bool _onlyLaunchableApps = false;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: _ListAppsPagesContent(
          includeSystemApps: _showSystemApps,
          onlyAppsWithLaunchIntent: _onlyLaunchableApps,
          key: GlobalKey()),
    );
  }
}


class _ListAppsPagesContent extends StatelessWidget {
  final bool includeSystemApps;
  final bool onlyAppsWithLaunchIntent;

  const _ListAppsPagesContent(
      {Key key,
        this.includeSystemApps: false,
        this.onlyAppsWithLaunchIntent: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 32.0, top: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "Chinese Apps",
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),SizedBox(height: 10,),
        Expanded(
          child: FutureBuilder(
              future: DeviceApps.getInstalledApplications(
                  includeAppIcons: true,
                  includeSystemApps: includeSystemApps,
                  onlyAppsWithLaunchIntent: onlyAppsWithLaunchIntent),
              builder: (context, data) {
                if (data.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<Application> apps = data.data;
                  List c = [];
                  print(apps);
                  for (var o in apps) {
                    if(cl.contains(o.appName))
                    c.add(o);
                    print("inside -->$c");

                  }

                  return c.isEmpty?Column(
                    children: <Widget>[
                      Center(
                        child: Container(padding: EdgeInsets.all(10.0),
                          child: Text("No apps found matching the database.\n"
                              "If it is an mistake please help us to add the chinese app to the list",
                            style: Theme.of(context).textTheme.body2,),

                        ),
                      ),
                      Container(height: 20,
                        child: BannerAdPage(),
                      ),
                     FlatButton(
                       child: Text("Installed apps",
                         style: Theme.of(context).textTheme.body2,),
                       onPressed: (){
                         Navigator.push(context, MaterialPageRoute(
                           builder: (context)=> ListAppsPages()
                         ));
                       },
                     ),
                    ],
                  ):
                  ListView.builder(shrinkWrap: true,
                      itemBuilder: (context, position) {
                        Application app = apps[position];
                        print (app);
                        if(cl.contains(app.appName))
                          return Column(
                            children: <Widget>[

                              Card(color: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                child: ListTile(

                                  leading: app is ApplicationWithIcon
                                      ? CircleAvatar(
                                    backgroundImage: MemoryImage(app.icon),
                                    backgroundColor: Colors.white,
                                  )
                                      : null,
                                  onLongPress: () => DeviceApps.openApp(app.packageName),
                                  title: Text("${app.appName} ",
                                      style: Theme.of(context).textTheme.body1),
                                  subtitle: Text('Version: ${app.versionName}\nSystem app: ${app.systemApp}\n',
                                      style: Theme.of(context).textTheme.body2),
                                  trailing: IconButton(icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: (){
                                      final AndroidIntent intent =  AndroidIntent(
                                        action: 'action_application_details_settings',
                                        data: 'package:${app.packageName}',
                                      );
                                      intent.launch();
                                    },),
                                ),
                              ),
                              Divider(
                                height: 3.0,
                              )
                            ],
                          );


                      },
                      itemCount: apps.length);
                }
              }),
        ),],
    );
  }

}