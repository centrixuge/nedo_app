import 'detail_reserve.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// widgetツリー
// MyApp -> MaterialApp-> Scaffold -> Center -> Column -> Text

// firestoreに接続できるようにmainを書き換え
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          primarySwatch: Colors.red,
          // primaryColor: PrimaryColor,
          // PrimaryColor全体を変更したくない場合は、
          // ThemeData AppBarThemeを定義することもできます。
          appBarTheme: AppBarTheme(
            color: const Color(0xFF151026),
          )),
      // リスト一覧画面を表示
      // home: Itinerary(),
      home: LoginPage(),
    );
  }
}

// Scaffold 内において，appBar/body/floatingActionButton などは並列で，
// それぞれの(appBar等)内部でchildをもつ
// appBarを追加して，リストを並べる
// body中のColumnは縦に複数のウィジェットを並べて配置する時に使う

// 色を宣言
const PrimaryColor = const Color(0xFF151026);

// ラジオボタンとして実装
enum RadioValue { FIRST, SECOND, THIRD, FOURTH }

// ログイン用フォーム
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}
// ログイン・認証系の参考
// https://www.flutter-study.dev/firebase-app/authentication

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  late final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return DetailReserve(result.user!);
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "登録に失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlinedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return DetailReserve(result.user!);
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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