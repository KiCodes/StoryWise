import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static Future<void> saveStories(List<String> stories) async {
    // Get a reference to the root of the Firebase database
    final database = FirebaseDatabase.instance.ref();

    // Get a reference to the "stories" child node
    final storiesRef = database.child('_stories');

    // Loop through the stories and save each one as a separate child node
    for (int i = 0; i < stories.length; i++) {
      final storyRef = storiesRef.child('story_$i');
      await storyRef.set({'content': stories[i]});
    }


    Future<void> fetchData() async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('_stories').get();
      snapshot.docs.forEach((DocumentSnapshot document) {
        // Access data from each document
        Object? data = document.data();
        // Process the data as needed
      });
    }

    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('_stories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        List<DocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot<Map<String, dynamic>> document = documents[index];
            String content = document['content'];
            String heading = document['heading'];
            String mood = document['mood'];
            String timeCreated = document['time_created'];

            // Use the retrieved data in your app UI
            // For example, display the content in a Text widget
            return Text(content);
          },
        );
      },
    );


  }
}
