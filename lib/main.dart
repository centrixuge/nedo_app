import 'detail_reserve.dart';
import 'driver_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'user_auth.dart';
import 'driver_auth.dart';

// widgetツリー
// MyApp -> MaterialApp-> Scaffold -> Center -> Column -> Text

// firestoreに接続できるようにmainを書き換え
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'Ridesharing App',
      theme: ThemeData(
        // テーマカラー
          primarySwatch: Colors.blueGrey,
          // primaryColor: PrimaryColor,
          // PrimaryColor全体を変更したくない場合は、
          // ThemeData AppBarThemeを定義することもできます。
          appBarTheme: AppBarTheme(
            color: Color(0xFFFF8A65),
          )),
      // リスト一覧画面を表示
      // home: Itinerary(),
      home: UserType(),
    );
  }
}

// Scaffold 内において，appBar/body/floatingActionButton などは並列で，
// それぞれの(appBar等)内部でchildをもつ
// appBarを追加して，リストを並べる
// body中のColumnは縦に複数のウィジェットを並べて配置する時に使う

// 色を宣言
const PrimaryColor = Color(0xFFFFCCBC);

class UserType extends StatefulWidget {

  @override
  _UserTypeState createState() => _UserTypeState();
}

// ラジオボタンとして実装
enum RadioValue { Driver, Rider }

class _UserTypeState extends State<UserType> {
  // メッセージ表示用
  String usertype = '';
  RadioValue _gValue = RadioValue.Rider;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: SafeArea(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const SizedBox(
  //               height: 50.0,
  //             ),
  //           RadioListTile(
  //             title: Text('登録ドライバー'),
  //             // subtitle: Text('自宅 <-> 花街道つけち / 往復'),
  //             value: RadioValue.Driver,
  //             groupValue: _gValue,
  //             onChanged: (value) => _onRadioSelected(value),
  //           ),
  //           RadioListTile(
  //             title: Text('ライドシェアサービス利用者'),
  //             // subtitle: Text('自宅 <-> アートピア付知 / 往復'),
  //             value: RadioValue.Rider,
  //             groupValue: _gValue,
  //             onChanged: (value) => _onRadioSelected(value),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => (_gValue ==  RadioValue.Driver) ? () => _onButtonPressed_D() : _onButtonPressed_R(),
  //             child: Text('ログイン画面に進む')),
  //           ],
  //         ),
  //       ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログインユーザー設定'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(height:10),
              alignment: Alignment.center,
              width: 400,
              height: 10,
              // color: Colors.indigoAccent,
              // child: Text("アイコンをタッチしてください", style: TextStyle(color: Colors.white)),
            ),
          ),

          Center(
            child: Container(
            alignment: Alignment.center,
            width: 400,
            height: 30,
            color: Colors.indigoAccent,
            child: Text("アイコンをタッチしてください", style: TextStyle(color: Colors.white)),
            ),
          ),

          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: FittedBox(
                        child: IconButton(
                            onPressed: () => _onButtonPressed_D(),
                            icon: Icon(Icons.drive_eta_outlined)
                        )
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: FittedBox(
                      child: IconButton(
                          onPressed: () => _onButtonPressed_R(),
                          icon: Icon(Icons.supervised_user_circle_sharp)
                      )
                  ),
                ),
                )
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: <Widget>[
          //       Expanded(
          //         child: ConstrainedBox(
          //           constraints: BoxConstraints.expand(height: 15.0),
          //           // margin: EdgeInsets.all(5.0),
          //           // decoration: BoxDecoration(
          //               // border: Border.all(color: Colors.pink.shade400)
          //           // ),
          //           child: FittedBox(
          //             fit: BoxFit.fitWidth,
          //             child: Text("登録ドライバー", textAlign: TextAlign.center, maxLines: 1,
          //               overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10)),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: ConstrainedBox(
          //           // margin: EdgeInsets.all(5.0),
          //           constraints: BoxConstraints.expand(height: 15.0),
          //           child:FittedBox(
          //             fit: BoxFit.fitWidth,
          //             child: Text("ライドシェア利用", textAlign: TextAlign.center, maxLines: 1,
          //               overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10))
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 40.0),
                    child: Text("登録ドライバー", textAlign: TextAlign.center, maxLines: 1,
                          overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 24)),
                  ),
                ),

                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 40.0),
                    child: Text("ライドシェア利用", textAlign: TextAlign.center, maxLines: 1,
                            overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 24))
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //    appBar: AppBar(
    //        title: Text('BMI CALCULATOR'),
    //    )
    //
    //    body: Column(
    //      children: <Widget>[
    //         Expanded(
    //           child: Row(
    //        const Text("登録ドライバー"),
    //        const Text("ライドシェア利用"),
    //      ]
    //    )
    //
    //     child:Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children:[
    //         IconButton(
    //           icon: Icon(Icons.drive_eta_outlined),
    //           onPressed: () => _onButtonPressed_D(),
    //           iconSize: 180,
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.supervised_user_circle_sharp),
    //           onPressed: () => _onButtonPressed_R(),
    //           iconSize: 180,
    //         ),
    //       ]
    //     ),
    //
    //
    //       children:[
    //
    //       ]
    //     )
    //     )
    // );
  }

  // _onRadioSelected(value) {
  //   setState(() {
  //     _gValue = value;
  //   });
  // }

  _onButtonPressed_D(){
    // final usertype = _gValue;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverAuth()),
      // MaterialPageRoute(builder: (context) => Timing(user: user, origin: origin, destination: destination)),
      // 遷移先の画面としてリスト追加画面を指定
      // onPressedには、(){}というカッコを書きます。
      // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
    );
  }

  _onButtonPressed_R(){
    // final usertype = _gValue;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserAuth()),
      // MaterialPageRoute(builder: (context) => Timing(user: user, origin: origin, destination: destination)),
      // 遷移先の画面としてリスト追加画面を指定
      // onPressedには、(){}というカッコを書きます。
      // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
    );
  }
}



// class ChatPage extends StatelessWidget {
//   // 引数からユーザー情報を受け取れるようにする
//   ChatPage(this.user);
//   // ユーザー情報
//   final User user;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('チャット'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               // ログアウト処理
//               // 内部で保持しているログイン情報等が初期化される
//               // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
//               await FirebaseAuth.instance.signOut();
//               // ログイン画面に遷移＋チャット画面を破棄
//               await Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) {
//                   return LoginPage();
//                 }),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         // ユーザー情報を表示
//         child: Text('ログイン情報：${user.email}'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           // 投稿画面に遷移
//           await Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) {
//               return DetailReserve();
//             }),
//           );
//         },
//       ),
//     );
//   }
// }



// 旅程のリストを最初から与えておくパタン(最初のver)

// ラジオボタンとして実装
// enum RadioValue { FIRST, SECOND, THIRD, FOURTH }


// class Itinerary extends StatefulWidget {
//   @override
//   _ItineraryState createState() => _ItineraryState();
// }

// class _ItineraryState extends State<Itinerary> {
//   RadioValue _gValue = RadioValue.FIRST;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         title: Text('現在利用可能な旅程の例'),
//     // ウィジェットレベルで変更したい場合は、 backgroundColor を定義して変更
//     backgroundColor: PrimaryColor,
//     ),
//
// // RadioListTileのパラメータ：
// // titleはラジオボタンのタイトル
// // subtitleはラジオボタンのサブタイトル
// // secondaryはアイコンなどをつけたい場合に利用してください。
// // controlAffinityではラジオボタンの配置を変更できます。
// // ListTileControlAffinity.leadingは先頭にラジオボタンを持ってきます。
// // ListTileControlAffinity.trailingは末尾にラジオボタンを持ってきます。
// // ListTileControlAffinity.platformは実行しているプラットフォームに対して
// // 一般的な配置にラジオボタンを持ってきます。
//
//     body: SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 50.0,
//           ),
//           RadioListTile(
//             title: Text('11月17日 12時-13時'),
//             subtitle: Text(
//               '自宅 <-> 花街道つけち / 往復',
//               style: TextStyle(color: Colors.black, fontSize: 16),
//             ),
//             value: RadioValue.FIRST,
//             groupValue: _gValue,
//             onChanged: (value) => _onRadioSelected(value),
//           ),
//           RadioListTile(
//             title: Text('11月17日 12時-14時'),
//             subtitle: Text('自宅 <-> 花街道つけち / 往復'),
//             value: RadioValue.SECOND,
//             groupValue: _gValue,
//             onChanged: (value) => _onRadioSelected(value),
//           ),
//           RadioListTile(
//             title: Text('11月17日 12時30分-13時'),
//             subtitle: Text('自宅 <-> アートピア付知 / 往復'),
//             value: RadioValue.THIRD,
//             groupValue: _gValue,
//             onChanged: (value) => _onRadioSelected(value),
//           ),
//           RadioListTile(
//             title: Text('11月17日 10時-11時30分'),
//             subtitle: Text('自宅 -> 東大 / 片道'),
//             value: RadioValue.FOURTH,
//             groupValue: _gValue,
//             onChanged: (value) => _onRadioSelected(value),
//           ),
//         ],
//       ),
//     ),
//
//     //   body: StreamBuilder<QuerySnapshot>(
//       //   StreambuilderはStreamから流れてくるイベントを監視（リッスン）します。
//       //   StreamBuilderがクラウド上のデータを監視してくれて、
//       // 変更があった場合はその変更をキャッチし、画面に反映してくれる。
//       // 開発者はわざわざクラウドの状態を確認するロジックを書く必要が無い。
//     //  https://bukiyo-papa.com/streambuilder/
//     //     stream:
//     //     FirebaseFirestore.instance.collection("itineraries").snapshots(),
//     //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     //       if (snapshot.connectionState == ConnectionState.waiting) {
//     //         return Center(child: CircularProgressIndicator());
//     //       }
//     //       return ListView(
//     //         children: snapshot.data!.docs.map((DocumentSnapshot document) {
//     //           return Card(
//     //             child: ListTile(
//     //               title: Text(document.get('month') +
//     //                   "月" +
//     //                   document.get('date') +
//     //                   "日" +
//     //                   " " +
//     //                   document.get('dep_time') +
//     //                   "-" +
//     //                   document.get("arr_time")),
//     //               // title: const Text("タイトル改改改"),
//     //               // title: FirebaseFirestore.instance.collection('posts').doc('ogN84F3pumPh8NWvBgYE').get(),
//     //               subtitle: Text(document.get('type') +
//     //                   ": " +
//     //                   document.get('origin') +
//     //                   "<->" +
//     //                   document.get('destination')),
//     //             ),
//     //           );
//     //         }).toList(),
//     //       );
//     //     },
//     //   ),
//
//       // https://flutter.keicode.com/basics/floatingactionbutton.php
//       // ラベル付きのfloatingは.extendedで設定
//       floatingActionButton: FloatingActionButton.extended(
//           label: Text('旅程を詳細に設定する'),
//           icon: Icon(Icons.add),
//           onPressed: () {
//             // "push"で新規画面に遷移
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DetailReserve()),
//               // 遷移先の画面としてリスト追加画面を指定
//               // onPressedには、(){}というカッコを書きます。
//               // この後{}の中に、ボタンを押した時に呼ばれるコードを書いていきます。
//             );
//           }
//         // child: Icon(Icons.add),
//       ),
//       // ボタンの位置を中央に指定
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   _onRadioSelected(value) {
//     setState(() {
//       _gValue = value;
//     });
//   }
// }