import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> with WidgetsBindingObserver {
  
  final _bgmAudioPlayer = AssetsAudioPlayer();
  final _playerAudioPlayer = AssetsAudioPlayer();

  final _bgm = Audio('assets/audio/BGM.mid');
  final _error = Audio('assets/audio/Error.wav');
  final _playerSound = Audio('assets/audio/PlayerX.wav');
  
  String _imagen1 = 'assets/images/empty.png';
  String _imagen2 = 'assets/images/empty.png';
  String _imagen3 = 'assets/images/empty.png';
  String _imagen4 = 'assets/images/empty.png';
  String _imagen5 = 'assets/images/empty.png';
  String _imagen6 = 'assets/images/empty.png';
  String _imagen7 = 'assets/images/empty.png';
  String _imagen8 = 'assets/images/empty.png';
  String _imagen9 = 'assets/images/empty.png';
  String _mensajeFinDeJuego = '';
  bool   _turnoJugador1 = true;
  bool   _permiteJugar = true;
  int    _tableroCompleto = 0;
  int    _contadorX = 0;
  int    _contadorO = 0;
 
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state){
      case AppLifecycleState.resumed:
        _bgmAudioPlayer.play();
        break;
      case AppLifecycleState.inactive:
        _bgmAudioPlayer.pause();
        break;
      case AppLifecycleState.paused:
        _bgmAudioPlayer.pause();
        break;
      case AppLifecycleState.detached:
        _bgmAudioPlayer.stop();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bgmAudioPlayer.open(_bgm, loop: true, volume: 0.2, respectSilentMode: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerAudioPlayer.dispose();
    _bgmAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Flutter TicTacToe'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.info), onPressed: () {
            showAboutDialog(
              context: context,
              applicationIcon: Container(child: Image.asset('assets/images/TTT_Logo.PNG', fit: BoxFit.contain),height: 100, width: 100,),
              applicationName: 'Flutter Tic Tac Toe',
              applicationVersion: '2.0.0',
              children: <Widget>[
                Text('Desarrollador', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                Text('Paul Pérez'),
                SizedBox(
                  height: 10.0,
                ),
                Text('Líneas de Código', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                Text('400+'),
                SizedBox(
                  height: 10.0,
                ),
                Text('Tiempo de Desarrollo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                Text('12+ hrs.'),
              ],
            );
          }),
        ],
      ),
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            // Valido que el tablero esté incompleto y que ningún jugador haya ganado
            if (_tableroCompleto < 9 && !_contarJugadas('x') && !_contarJugadas('o')) {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text('Confirmación'),
                  content: Text('Al continuar el juego será reiniciado, ¿desea continuar?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: Text('Cancelar')
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _reiniciar();
                        }); 
                        Navigator.pop(context);
                      }, 
                      child: Text('Reiniciar', style: TextStyle(color: Colors.red),)
                    ),
                  ],
                )
              );
            } else {
              _reiniciar();
            }
          });
        },
        child: Icon(Icons.refresh),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            contadores(),
            SizedBox(
              height: 50.0,
            ),
            tablero(),
          ],
        ),
      ),
    );
  }
  
  /// Genera el tablero del juego.
  Widget tablero() {
    return Stack(
      children: <Widget>[
        Container(
          width: 380,
          height: 320,
          child: Image.asset('assets/images/tablero.PNG'),
        ),
        Container(
          width: 380,
          height: 380,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Table(
                children: [
                  TableRow(
                    children: [
                      boton(1, _imagen1),
                      boton(2, _imagen2),
                      boton(3, _imagen3),
                    ]
                  ),
                  TableRow(
                    children: [
                      boton(4, _imagen4),
                      boton(5, _imagen5),
                      boton(6, _imagen6),
                    ]
                  ),
                  TableRow(
                    children: [
                      boton(7, _imagen7),
                      boton(8, _imagen8),
                      boton(9, _imagen9),
                    ]
                  ),
                ],
              ),
          ),
        ),
      ],
    );
  }

  /// Verifica que la jugada sea válida
  Future jugada(int botonID, String imagen) async {
    switch (botonID) {
      case 1:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen1 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen1 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 2:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen2 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen2 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 3:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen3 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen3 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 4:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen4 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen4 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 5:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen5 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen5 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 6:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen6 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen6 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 7:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen7 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen7 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 8:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen8 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen8 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      case 9:
        if (imagen == 'assets/images/empty.png') {
          _playerAudioPlayer.open(_playerSound);
          if (_turnoJugador1) {
            _imagen9 = 'assets/images/x.png';
            _turnoJugador1 = false;
          } else {
            _imagen9 = 'assets/images/o.png';
            _turnoJugador1 = true;
          }
          _tableroCompleto++; 
        } else {
          _playerAudioPlayer.open(_error);
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
        }
        break;
      default:
        break;
    }
    _verificarTablero();
  }

  /// Botones que conforman el tablero.
  Widget boton(int botonID, String imagen) {
    return FlatButton(
      key: ValueKey(botonID),
      child: Image.asset(imagen, width: 50, height: 100),
      onPressed: _permiteJugar ? () => setState(() {jugada(botonID, imagen);}) : null,
      //onPressed: _enabledButtons ? () => jugada(botonID, imagen) : null,
    );
  }

  /// Verifica las jugadas en el tablero para determinar si la última jugada genera un ganador.
  void _verificarTablero() {
    String jugador = 'x';
    for (var i = 0; i < 2; i++) {
      if (_contarJugadas(jugador)) {
        _mensajeFinDeJuego = 'El jugador ${i+1} (${jugador.toUpperCase()}) ha ganado!';
        if (jugador == 'x') {
          _contadorX++;
        } else {
          _contadorO++;
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          child: alerta(),
        );
        break;
      } else {
        // Se verifica si es la segunda corrida y si el tablero esta lleno
        if (i == 1 && _tableroCompleto == 9) {
          _mensajeFinDeJuego = 'EMPATE!';
          showDialog(
            context: context,
            barrierDismissible: false,
            child: alerta(),
          );
        }
      }
      jugador = 'o';
    }
  }

  /// Reinicia las variables del juego.
  void _reiniciar() {
    _imagen1 = 'assets/images/empty.png';
    _imagen2 = 'assets/images/empty.png';
    _imagen3 = 'assets/images/empty.png';
    _imagen4 = 'assets/images/empty.png';
    _imagen5 = 'assets/images/empty.png';
    _imagen6 = 'assets/images/empty.png';
    _imagen7 = 'assets/images/empty.png';
    _imagen8 = 'assets/images/empty.png';
    _imagen9 = 'assets/images/empty.png';
    _mensajeFinDeJuego = '';
    _turnoJugador1 = true;
    _permiteJugar  = true;
    _tableroCompleto = 0;
  }

  /// Retorna ['true'] cuando uno de los jugadores ha conseguido ganar, ['False'] en caso contrario.
  bool _contarJugadas(String jugador) {

    // Horizontal 1, 2 y 3
    int h1 = 0;
    int h2 = 0;
    int h3 = 0;
    // Vertical 1, 2 y 3
    int v1 = 0;
    int v2 = 0;
    int v3 = 0;
    // Diagonal 1 y 2
    int d1 = 0;
    int d2 = 0;

    if (_imagen1 == 'assets/images/$jugador.png') {
      h1++;
      v1++;
      d1++;
    }
    if (_imagen2 == 'assets/images/$jugador.png') {
      h1++;
      v2++;
    }
    if (_imagen3 == 'assets/images/$jugador.png') {
      h1++;
      v3++;
      d2++;
    }
    if (_imagen4 == 'assets/images/$jugador.png') {
      h2++;
      v1++;
    }
    if (_imagen5 == 'assets/images/$jugador.png') {
      h2++;
      v2++;
      d1++;
      d2++;
    }
    if (_imagen6 == 'assets/images/$jugador.png') {
      h2++;
      v3++;
    }
    if (_imagen7 == 'assets/images/$jugador.png') {
      h3++;
      v1++;
      d2++;
    }
    if (_imagen8 == 'assets/images/$jugador.png') {
      h3++;
      v2++;
    }
    if (_imagen9 == 'assets/images/$jugador.png') {
      h3++;
      v3++;
      d1++;
    }

    // Si alguna de las variables suma 3 significa que hay 3 jugadas en linea del mismo player, ya sea horizontal, veritical o diagonal.
    if (h1 == 3 || h2 == 3 ||h3 == 3 || v1 == 3 || v2 == 3 || v3 == 3 || d1 == 3 || d2 == 3) {
      _permiteJugar = false;
      return true;
    }
    return false;
  }

  /// Muestra el resultado de la partida.
  Widget alerta() {
    return AlertDialog(
      title: Text('RESULTADO'),
      content: Text(_mensajeFinDeJuego),
      scrollable: false,
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar')),
      ],
    );
  }

  /// Muestra el contador para los jugadores ['X'] y ['Y'].
  Widget contadores() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Ganadas por X', style: TextStyle(fontSize: 20, color: Colors.blue[300], fontWeight: FontWeight.bold)),
            Text('${_contadorX.toString()}', style: TextStyle(fontSize: 30),),
          ],
        ),
        SizedBox(
          width: 50.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Ganadas por O', style: TextStyle(fontSize: 20, color: Colors.red[300], fontWeight: FontWeight.bold)),
            Text('${_contadorO.toString()}', style: TextStyle(fontSize: 30),),
          ],
        )
      ],
    );
  }
}