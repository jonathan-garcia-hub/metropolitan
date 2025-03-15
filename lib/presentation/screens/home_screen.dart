import 'package:flutter/material.dart';
import '../../data/repositories/member_repository.dart';
import 'user_activities_screen.dart';
import 'all_activities_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice de la sección activa
  String _userName = ''; // Nombre del usuario

  final List<Widget> _screens = [
    UserActivitiesScreen(),
    AllActivitiesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final memberRepository = MemberRepository();
    final member = await memberRepository.getMember(1); // Asumimos que el usuario logueado tiene ID 1
    setState(() {
      _userName = '${member.name} ${member.lastName}';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Management App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Sin funcionalidad
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sección de bienvenida
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[50], // Fondo diferenciado
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alineado a la derecha
              children: [
                Text(
                  'Bienvenido, $_userName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Título de la sección activa
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              _selectedIndex == 0 ? 'Mis Actividades' : 'Todas las Actividades',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Contenido de la pantalla seleccionada
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color de la sección activa
        unselectedItemColor: Colors.grey, // Color de las secciones inactivas
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Mis Actividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Todas las Actividades',
          ),
        ],
      ),
    );
  }
}