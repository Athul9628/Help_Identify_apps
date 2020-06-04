import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:removechina/chinaapp.dart';
import 'package:removechina/installed_apps.dart';
import 'app_state.dart';
import 'app_theme.dart';

void main() => runApp(
  ChangeNotifierProvider<AppState>(
    builder: (context) => AppState(),
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          home: TaskPage(),
        );
      },
    );
  }
}

class TaskPage extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        ),
      drawer: Drawer(
        child: Container(
          color:Theme.of(context).appBarTheme.color ,
          child: ListView(
            children: <Widget>[Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Dark Mode',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  Spacer(),
                  Switch(
                      value: Provider.of<AppState>(context).isDarkModeOn,
                      onChanged: (booleanValue) {
                        Provider.of<AppState>(context).updateTheme(booleanValue);
                      }),
                ],
              ),
            ),FlatButton(
              child: Text("All apps",style: Theme.of(context).textTheme.body2,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ListAppsPages()));
              },
            )],
          ),
        ),
      ),
      body: chinaapplist(),


    );
  }
}