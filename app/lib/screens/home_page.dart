import 'package:app/screens/login_page.dart';
import 'package:app/screens/mapa_page.dart';
import 'package:app/screens/perfil_page.dart';
import 'package:app/screens/rotas_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  List<Widget> _screens = [MapaPage(), RotasPage(), PerfilPage()];
  // List<Widget> _screens1 = [RotasPage(), MapaPage(), PerfilPage()];

  void _onPageChanged(int index) {}
  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
    // print(selectedIndex);
  }

  Future showWidget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt('pessoaId', 1);
    return await prefs.getInt('pessoaId');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _screens,
        //     [
        //   FutureBuilder<dynamic>(
        //       future: showWidget(),
        //       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //         // List<Widget> children1;
        //         if (snapshot.hasData) {
        //           return PageView(children: _screens1);
        //         } else if (snapshot.hasError) {
        //           return PageView(children: _screens);
        //         }
        //         return (Text("Erro"));
        //       }),
        // ],
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: 'Rotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Perfil',
          ),
          // if ('pessoaId' == true)
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.account_circle_outlined),
          //     label: 'Perfil',
          //   )
          // else
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.account_circle),
          //     label: 'Login',
          //   ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
