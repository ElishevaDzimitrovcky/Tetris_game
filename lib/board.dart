import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'piece.dart';
import 'title.dart';
import 'values.dart' as values;

const int rowLength = 10;
const int columnLength = 15;

List<List<values.TetrisShape?>> gameBoard = List.generate(
  columnLength,
  (_) => List.generate(rowLength, (_) => null),
);

class GameBoard extends StatefulWidget {
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late Piece currentPiece;
  int currentScore = 0;
  bool gameOver = false;

  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    createNewPiece();
    gameLoop(Duration(milliseconds: 500));
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        clearLines();
        checkLanding();
        if (gameOver) {
          timer.cancel();
          showGameOverDialog();
        }
        currentPiece.movePiece(values.Direction.down);
      });
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Your Score is: $currentScore"),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.of(context).pop();
            },
            child: Text("PLAY AGAIN"),
          ),
        ],
      ),
    );
  }

  bool checkCollision({values.Direction? direction}) {
    return currentPiece.position.any((pos) {
      int row = (pos / rowLength).floor();
      int col = (pos % rowLength);
      if (direction == values.Direction.left) col -= 1;
      if (direction == values.Direction.right) col += 1;
      if (direction == values.Direction.down) row += 1;
      return row >= columnLength ||
          col < 0 ||
          col >= rowLength ||
          (row >= 0 && col >= 0 && gameBoard[row][col] != null);
    });
  }

 void checkLanding() {
  if (checkCollision(direction: values.Direction.down)) {
    for (int pos in currentPiece.position) {
      int row = (pos / rowLength).floor();
      int col = pos % rowLength;
      if (row >= 0 && row < columnLength && col >= 0 && col < rowLength) {
        gameBoard[row][col] = currentPiece.type; // הנחת על הלוח
      }
    }
    createNewPiece();
  }
}

  bool isGameOver() {
    return gameBoard[0].any((cell) => cell != null);
  }

  void createNewPiece() {
    currentPiece = Piece(
        type: values.TetrisShape
            .values[Random().nextInt(values.TetrisShape.values.length)]);
    currentPiece.initiallizePiece();
    if (isGameOver()) gameOver = true;
  }

  void clearLines() {
    for (int row = columnLength - 1; row >= 0; row--) {
      if (gameBoard[row].every((cell) => cell != null)) {
        for (int r = row; r > 0; r--)
          gameBoard[r] = List.from(gameBoard[r - 1]);
        gameBoard[0] = List.generate(rowLength, (_) => null);
        currentScore++;
      }
    }
  }

  void moveLeft() {
    if (!checkCollision(direction: values.Direction.left)) {
      setState(() {
        currentPiece.movePiece(values.Direction.left);
      });
    }
    checkLanding();
  }

  void moveRight() {
    if (!checkCollision(direction: values.Direction.right)) {
      setState(() {
        currentPiece.movePiece(values.Direction.right);
      });
    }
    checkLanding();
  }

  void rotatePiece() {
    currentPiece.rotatePiece();
    checkLanding();
  }

  void resetGame() {
    gameBoard = List.generate(
      columnLength,
      (_) => List.generate(rowLength, (_) => null),
    );
    currentScore = 0;
    gameOver = false;
    createNewPiece();
    startGame();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: GridView.builder(
              itemCount: rowLength * columnLength,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int col = index % rowLength;
                Color color;
                if (currentPiece.position.contains(index)) {
                  color = currentPiece.color;
                } else if (gameBoard[row][col] != null) {
                  color = values.tetrisShapeColors[gameBoard[row][col]]!;
                } else {
                  color = Colors.grey[900]!;
                }
                return Tile(
                  color: color,
                );
              },
            )),
            Padding(padding: EdgeInsets.all(25),
            child: Text('Score: $currentScore',
            style: TextStyle(
               fontSize: 20,
            color: Colors.white),),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: moveLeft,
                    color: Colors.grey,
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  IconButton(
                    onPressed: rotatePiece,
                    color: Colors.grey,
                    icon: Icon(Icons.rotate_right),
                  ),IconButton(
                    onPressed: moveRight,
                    color: Colors.grey,
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
