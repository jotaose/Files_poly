import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:archivos_polyrev/rol_finanzas.dart';
import 'package:archivos_polyrev/rol_operaciones.dart';
import 'package:archivos_polyrev/rol_rrhh.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  //final User user;

  //const ProfilePage({required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  //late User _currentUser;

  @override
  void initState() {
    //_currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'chupalo usuario'), //Text('Usuario Actual : ${_currentUser.email}'),
        //title: Text('Usuario Actual '),
      ),
      body: ListView(
        children: <Widget>[
          miCardFinanzas(),
          miCardRrhh(),
          miCardOperaciones(),
          miBtn(),
        ],
      ),
    );
  }

  Center miBtn() {
    return Center(
      child: _isSigningOut
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Cerrar Sesion'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
            ),
    );
  }

  Card miCardFinanzas() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          const ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('FINANZAS'),
            subtitle: Text('Todo lo relacionado con finanzas'),
            leading: Icon(Icons.money_rounded),
            //cambiar el color de los iconos en las card
            //iconColor: Colors.amber,
            textColor: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => rolFinanzas(),
                          ),
                        )
                      },
                  child: const Text('Ir')),
              //TextButton(onPressed: () => {}, child: const Text('Cancelar'))
            ],
          ),
        ],
      ),
    );
  }

  //rrhh
  Card miCardRrhh() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          const ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('RRHH'),
            subtitle: Text('Todo lo relacionado con rrhh'),
            leading: Icon(Icons.account_circle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => rr_hh(),
                          ),
                        )
                      },
                  child: const Text('Ir')),
              //TextButton(onPressed: () => {}, child: const Text('Cancelar'))
            ],
          ),
        ],
      ),
    );
  }

  //operaciones
  Card miCardOperaciones() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          const ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('OPERACIONES'),
            subtitle: Text('Todo lo relacionado con operaciones'),
            leading: Icon(Icons.account_tree_rounded),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => terrenoObras(),
                          ),
                        )
                      },
                  child: const Text('Ir')),
              //TextButton(onPressed: () => {}, child: const Text('Cancelar'))
            ],
          ),
        ],
      ),
    );
    //btn cerrar sesion
  }
}
