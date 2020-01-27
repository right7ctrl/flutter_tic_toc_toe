import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TicTocToe()));

class TicTocToe extends StatefulWidget {
  @override
  _TicTocToeState createState() => _TicTocToeState();
}

class _TicTocToeState extends State<TicTocToe> {
  Player player = Player.HUMAN;
  Player winner;
  int rounds = 0;

  //0-initial
  //1-human
  //2-robot
  List<List<int>> grid = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                      minHeight: constraints.maxHeight * 0.2, maxHeight: constraints.maxHeight * 0.2, minWidth: constraints.maxHeight * 0.2, maxWidth: constraints.maxHeight * 0.2),
                  child: Column(
                    children: _buildRows(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                winner != null ? Text('Winner: ${winner == Player.ROBOT ? 'ROBOT' : 'ME'}') : Container(),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];
    for (int i = 0; i < grid.length; i++) {
      Widget row = Expanded(
        child: Row(
          children: _buildCells(rowID: i),
        ),
      );
      rows.add(row);
    }
    return rows;
  }

  List<Widget> _buildCells({@required int rowID}) {
    List<Widget> cells = [];
    for (int colID = 0; colID < grid.length; colID++) {
      Widget cell = Expanded(
        child: Material(
          child: InkWell(
            onTap: winner == null
                ? () {
              if (player == Player.HUMAN && grid[rowID][colID] == 0) {
                setState(() {
                  rounds++;
                  grid[rowID][colID] = 1;
                  player = Player.ROBOT;
                });
                //be sure if its the last round
                if (rounds != 5) _playAsRobot();
                //let's see the winner!
                _calcGameStatus();
              }
            }
                : null,
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
              child: Center(
                child: Text(
                  '${grid[rowID][colID] == 0 ? '' : grid[rowID][colID] == 1 ? 'X' : 'O'}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: grid[rowID][colID] == 1 ? Colors.green : Colors.red),
                ),
              ),
            ),
          ),
        ),
      );
      cells.add(cell);
    }
    return cells;
  }

  _playAsRobot() {
    if (player == Player.ROBOT) {
      int randomRow = Random().nextInt(grid.length);
      int randomCol = Random().nextInt(grid.length);
      print('$randomRow , $randomCol');
      if (grid[randomRow][randomCol] == 0) {
        setState(() {
          grid[randomRow][randomCol] = 2;
          player = Player.HUMAN;
        });
        _calcGameStatus();
      } else {
        _playAsRobot();
      }
    }
  }

  _calcGameStatus() {
    if ((grid[0][0] == 1 && grid[0][1] == 1 && grid[0][2] == 1) ||
        (grid[1][0] == 1 && grid[1][1] == 1 && grid[1][2] == 1) ||
        (grid[2][0] == 1 && grid[2][1] == 1 && grid[2][2] == 1) ||
        (grid[2][0] == 1 && grid[1][1] == 1 && grid[0][2] == 1) ||
        (grid[0][0] == 1 && grid[1][1] == 1 && grid[2][2] == 1) ||
        (grid[0][1] == 1 && grid[1][1] == 1 && grid[2][1] == 1) ||
        (grid[0][0] == 1 && grid[1][0] == 1 && grid[2][0] == 1) ||
        (grid[0][2] == 1 && grid[1][2] == 1 && grid[2][2] == 1)) {
      setState(() {
        winner = Player.HUMAN;
      });
    } else if ((grid[0][0] == 2 && grid[0][1] == 2 && grid[0][2] == 2) ||
        (grid[1][0] == 2 && grid[1][1] == 2 && grid[1][2] == 2) ||
        (grid[2][0] == 2 && grid[2][1] == 2 && grid[2][2] == 2) ||
        (grid[2][0] == 2 && grid[1][1] == 2 && grid[0][2] == 2) ||
        (grid[0][0] == 2 && grid[1][1] == 2 && grid[2][2] == 2) ||
        (grid[0][1] == 2 && grid[1][1] == 2 && grid[2][1] == 2) ||
        (grid[0][0] == 2 && grid[1][0] == 2 && grid[2][0] == 2) ||
        (grid[0][2] == 2 && grid[1][2] == 2 && grid[2][2] == 2)) {
      setState(() {
        winner = Player.ROBOT;
      });
    }
  }
}

enum Player { HUMAN, ROBOT }
