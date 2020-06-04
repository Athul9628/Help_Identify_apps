import 'package:device_apps/device_apps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:removechina/ads.dart';
import 'package:removechina/appinform.dart';
import 'package:removechina/database.dart';
import 'adsclass.dart';


class ListAppsPages extends StatefulWidget {
  @override
  _ListAppsPagesState createState() => _ListAppsPagesState();
}

class _ListAppsPagesState extends State<ListAppsPages> {


  bool _showSystemApps = false;
  bool _onlyLaunchableApps = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Installed applications",style:Theme.of(context).textTheme.body1,),

        backgroundColor: Theme.of(context).appBarTheme.color ,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    value: 'system_apps', child: Text('Toggle system apps',style: Theme.of(context).textTheme.body2,)),
                PopupMenuItem<String>(
                  value: "launchable_apps",
                  child: Text('Toggle launchable apps only',style: Theme.of(context).textTheme.body2,),
                )
              ];
            },
            onSelected: (key) {
              if (key == "system_apps") {
                setState(() {
                  _showSystemApps = !_showSystemApps;
                });
              }
              if (key == "launchable_apps") {
                setState(() {
                  _onlyLaunchableApps = !_onlyLaunchableApps;
                });
              }
            },
          )
        ],
      ),
      body: _ListAppsPagesContent(
          includeSystemApps: _showSystemApps,
          onlyAppsWithLaunchIntent: _onlyLaunchableApps,
          key: GlobalKey()),
    );
  }
}

class _ListAppsPagesContent extends StatelessWidget {
  final adsin ads;
  final bool includeSystemApps;
  final bool onlyAppsWithLaunchIntent;

  const _ListAppsPagesContent(
      {Key key,this.ads,
        this.includeSystemApps: false,
        this.onlyAppsWithLaunchIntent: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: includeSystemApps,
            onlyAppsWithLaunchIntent: onlyAppsWithLaunchIntent),
        builder: (context, data) {
          if (data.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data;
            print(apps);
            return ListView.builder(
                itemBuilder: (context, position) {
                  Application app = apps[position];

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
                          onTap: (){
                            showDialog(context: context,
                                child:AlertDialog(
                                  backgroundColor: Theme.of(context).appBarTheme.color,
                                  title: Text("Is it an chinese app?",
                                  style: Theme.of(context).textTheme.body1,),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("No",
                                      style: Theme.of(context).textTheme.body2,),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Yes",
                                        style: Theme.of(context).textTheme.body2,),
                                      onPressed: (){
                                        final databaseReference = FirebaseDatabase.instance.reference();
                                        databaseReference.push().set({
                                          'title': '${app.appName}',
                                          'description': '${app.packageName}'
                                        });
                                        Navigator.pop(context);
                                        final snackBar = SnackBar(
                                          content: Text('Yay! Thank you!'),
                                            behavior: SnackBarBehavior.floating,

                                        );

                                        // Find the Scaffold in the widget tree and use
                                        // it to show a SnackBar.
                                        Scaffold.of(context).showSnackBar(snackBar);

                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=>adsin()
                                        ));

                                      },
                                    )
                                  ],
                                ) );
                          },
                          onLongPress: () => DeviceApps.openApp(app.packageName),
                          title: Text("${app.appName} ",
                              style: Theme.of(context).textTheme.body1),
                          subtitle: Text('Version: ${app.versionName}\nSystem app: ${app.systemApp}\n',
                                           style: Theme.of(context).textTheme.body2),
                          trailing: IconButton(icon: Icon(Icons.arrow_right),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: (){ Navigator.push(context, MaterialPageRoute(
                              builder: (Context)=>Appinform(app: apps[position],)
                          ));

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
        });
  }
}