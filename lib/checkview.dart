import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';


// Future<void> View() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(Checkview());
// }

class Checkview extends StatelessWidget {
  String user;
  String? data;
  Checkview(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("旅程を確認する"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // body: FutureBuilder<QuerySnapshot>(
        //     future: FirebaseFirestore.instance.collection("requests").snapshots(),
          stream: FirebaseFirestore.instance.collection("requests").where('user', isEqualTo: user).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? ListView(
              children: snapshot.data!.docs.map((doc) {
              // children: snapshot.data!.docs.map((DocumentSnapshot document) {
                final data = doc.data()! as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    // title: Text('origin'),
                    title: Text('Origin: ${data['origin']} / Destination: ${data['destination']}'),
                    subtitle: Text('Depart at ${data['departure']} / Arrive at ${data['arrival']}'),

                    // 自分のリクエストのみが削除できるように
                    // trailing: data['email'] == user.email
                    //     ? IconButton(
                    //   icon: Icon(Icons.delete),
                    //   onPressed: () async {
                    //     // 投稿メッセージのドキュメントを削除
                    //     await FirebaseFirestore.instance
                    //         .collection('requests')
                    //         .doc(data.id)
                    //         .delete();
                    //   },
                    // ) : null,
                  ),
                );
              }).toList(),
            ): Center(child: CircularProgressIndicator());
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // }
            // // if (!snapshot.hasData) { //ここに追加
            // return ListView(
            //
            //   children: snapshot.data.docs.map((DocumentSnapshot document) {
            //     final data = document.data()! as Map<String, dynamic>;
            //     return Card(
            //       child: ListTile(
            //         title: Text('origin'),
            //         // title: Text('${data['origin']}'),
            //         // title: Text('${data['origin']},${data['destination']}'),
            //         subtitle: Text('Your request'),
            //       ),
            //     );
            //   }).toList(),
            // );
            // };
            }),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('最初に戻る'),
          icon: Icon(Icons.home),
          onPressed: () {
            // "push"で新規画面に遷移
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
              // 遷移先の画面としてリスト追加画面を指定
              // onPressedには、(){}というカッコを書きます。
              // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
          }
        // child: Icon(Icons.add),
      ),
    );
  }
}
