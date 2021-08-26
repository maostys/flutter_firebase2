import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Firebaseを初期化
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  //１ここに入力
  
  canvas.~~~~~

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAuthPage(),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  // 入力されたメールアドレス・パスワード（ログイン用）
  String loginUserEmail = "";
  String loginUserPassword = "";

  // 作成したドキュメント一覧
  List<DocumentSnapshot> documentList = [];
  String orderDocumentInfo = '';
  List<dynamic> docDate = [];

  String debugText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: <Widget>[
                    Text("判定" + debugText),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc('test')
                              .set({'name': 'ジョビ', 'age': 18});
                        },
                        child: Text('コレクション＋ドキュメント作成')),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc('test3')
                              .collection('orders')
                              .doc('test3-1')
                              .set({'price': 600, 'date': '9/13'});
                        },
                        child: Text('サブコレクション＋ドキュメント作成')),
                    ElevatedButton(
                        onPressed: () async {
                          final snapshot = await FirebaseFirestore.instance
                              .collection('users')
                              .get();
                          setState(() {
                            documentList = snapshot.docs;
                          });
                        },
                        child: Text('ドキュメント一覧取得')),
                    Column(
                      children: documentList.map((document) {
                        return ListTile(
                          title: Text('${document['name']}さん'),
                          subtitle: Text(
                              '${document['age']}歳'), //documentList.length.toString()
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final document = await FirebaseFirestore.instance
                              .collection('users')
                              .doc('id_abc')
                              .get();
                          // 取得したドキュメントの情報をUIに反映
                          setState(() {
                            // docDate:List<dynamic> String Map DocumentSnapshot×
                            docDate = document['test001'];
                            // orderDocumentInfo:String
                            orderDocumentInfo = "取得：${docDate[0].toString()}";

                            //orderDocumentInfo = "${document['test001']}";

                            //'${document['date']} ${document['price']}円';
                          });
                        },
                        child: Text('ドキュメントを指定して取得')),
                    ListTile(title: Text(orderDocumentInfo)),
                    ElevatedButton(
                        onPressed: () async {
                          // ドキュメントを更新
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc('test')
                              .update({
                            'array_field2':
                                FieldValue.arrayUnion(["userIDtest"])
                          });
                        },
                        child: Text('ドキュメントADD')),
                    ElevatedButton(
                        onPressed: () async {
                          // ドキュメントを更新
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc('test')
                              .update({'age': 99});
                        },
                        child: Text('ドキュメント更新')),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc('test')
                              .delete();
                        },
                        child: Text('ドキュメント削除')),
                    TextFormField(
                      // テキスト入力のラベルを設定
                      decoration: InputDecoration(labelText: "メールアドレス"),
                      onChanged: (String value) {
                        setState(() {
                          newUserEmail = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: "パスワード(6文字以上)"),
                      obscureText: true,
                      onChanged: (String value) {
                        setState(() {
                          newUserPassword = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          // メール・パスワードでユーザー登録
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final UserCredential result =
                              await auth.createUserWithEmailAndPassword(
                                  email: newUserEmail,
                                  password: newUserPassword);
                          // 登録したユーザー情報
                          final User user = result.user!;
                          setState(() {
                            infoText = "登録OK：${user.email}";
                          });
                        } catch (e) {
                          // 登録に失敗した場合
                          setState(() {
                            infoText = "登録NG：${e.toString()}";
                          });
                        }
                      },
                      child: Text("ユーザー登録"),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: "メールアドレス"),
                      onChanged: (String value) {
                        loginUserEmail = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "パスワード"),
                      obscureText: true,
                      onChanged: (String value) {
                        setState(() {
                          loginUserPassword = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            // メール・パスワードでログイン
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            final UserCredential result =
                                await auth.signInWithEmailAndPassword(
                                    email: loginUserEmail,
                                    password: loginUserPassword);
                            // ログインに成功した場合
                            final User user = result.user!;
                            setState(() {
                              infoText = "ログインOK：${user.email}";
                            });
                          } catch (e) {
                            setState(() {
                              infoText = "ログインNG:${e.toString()}";
                            });
                          }
                        },
                        child: Text("ログイン")),
                    const SizedBox(height: 8),
                    Text(infoText)
                  ],
                ))));
  }
}
