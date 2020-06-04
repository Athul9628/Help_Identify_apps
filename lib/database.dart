import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void createRecord(){
  databaseReference.child("1").set({
    'title': 'Mastering EJB',
    'description': 'Programming Guide for J2EE'
  });
  databaseReference.child("2").set({
    'title': 'Flutter in Action',
    'description': 'Complete Programming Guide to learn Flutter'
  });
}