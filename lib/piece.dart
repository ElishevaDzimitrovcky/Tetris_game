import 'dart:ui';
import 'board.dart';
import 'values.dart' as values;

class Piece {
  values.TetrisShape type;
  List<int> position = [];
  int rotationState = 0;

  Piece({required this.type});

  Color get color => values.tetrisShapeColors[type] ?? Color(0xFFFFFFFF);

  void initiallizePiece() {
    // אתחול מיקום
    switch (type) {
      case values.TetrisShape.L:
        position = [-26, -16, -6, -5];
        break;
      case values.TetrisShape.J:
        position = [-25, -15, -5, -6];
        break;
      case values.TetrisShape.I:
        position = [-4, -5, -6, -7];
        break;
      case values.TetrisShape.O:
        position = [-15, -16, -5, -6];
        break;
      case values.TetrisShape.S:
        position = [-15, -14, -6, -5];
        break;
      case values.TetrisShape.Z:
        position = [-17, -16, -6, -5];
        break;
      case values.TetrisShape.T:
        position = [-26, -16, -6, -15];
        break;
    }
  }

  void movePiece(values.Direction direction) {
    int offset = direction == values.Direction.down
        ? rowLength
        : (direction == values.Direction.left ? -1 : 1);
    for (int i = 0; i < position.length; i++) position[i] += offset;
  }

  // סיבוב החלק
  void rotatePiece() {
    List<int> newPosition = []; // מיקום חדש לאחר הסיבוב
    switch (type) {
      case values.TetrisShape.L:
        if (rotationState == 0)
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + rowLength + 1
          ]; // סיבוב למצב 0
        if (rotationState == 1)
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + rowLength - 1
          ]; // סיבוב למצב 1
        if (rotationState == 2)
          newPosition = [
            position[1] + rowLength,
            position[1],
            position[1] - rowLength,
            position[1] - rowLength - 1
          ]; // סיבוב למצב 2
        if (rotationState == 3)
          newPosition = [
            position[1] - rowLength + 1,
            position[1],
            position[1] + 1,
            position[1] - 1
          ]; // סיבוב למצב 3
        break;
      case values.TetrisShape.J:
        if (rotationState == 0)
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + rowLength - 1
          ]; // סיבוב למצב 0
        if (rotationState == 1)
          newPosition = [
            position[1] - rowLength - 1,
            position[1],
            position[1] - 1,
            position[1] + 1
          ]; // סיבוב למצב 1
        if (rotationState == 2)
          newPosition = [
            position[1] + rowLength,
            position[1],
            position[1] - rowLength,
            position[1] - rowLength + 1
          ]; // סיבוב למצב 2
        if (rotationState == 3)
          newPosition = [
            position[1] + 1,
            position[1],
            position[1] - 1,
            position[1] + rowLength + 1
          ]; // סיבוב למצב 3
        break;
      case values.TetrisShape.I:
        if (rotationState == 0 || rotationState == 2)
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + 2
          ]; // סיבוב למצב 0 או 2
        if (rotationState == 1 || rotationState == 3)
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + 2 * rowLength
          ]; // סיבוב למצב 1 או 3
        break;
      case values.TetrisShape.O:
        newPosition = position; // חלק O לא מסתובב
        break;
      case values.TetrisShape.S:
      case values.TetrisShape.Z:
        if (rotationState == 0 || rotationState == 2)
          newPosition = [
            position[1],
            position[1] + 1,
            position[1] + rowLength - 1,
            position[1] + rowLength
          ]; // סיבוב למצב 0 או 2
        if (rotationState == 1 || rotationState == 3)
          newPosition = [
            position[0] - rowLength,
            position[0],
            position[0] + 1,
            position[0] + rowLength + 1
          ]; // סיבוב למצב 1 או 3
        break;
      case values.TetrisShape.T:
        if (rotationState == 0)
          newPosition = [
            position[2] - rowLength,
            position[2],
            position[2] + 1,
            position[2] + rowLength
          ]; // סיבוב למצב 0
        if (rotationState == 1)
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + rowLength
          ]; // סיבוב למצב 1
        if (rotationState == 2)
          newPosition = [
            position[1] - rowLength,
            position[1] - 1,
            position[1],
            position[1] + rowLength
          ]; // סיבוב למצב 2
        if (rotationState == 3)
          newPosition = [
            position[2] - rowLength,
            position[2] - 1,
            position[2],
            position[2] + 1
          ]; // סיבוב למצב 3
        break;
    }
    // אם המיקום החדש תקין, עדכון מיקום החלק ומצב הסיבוב
    if (piecePositionIsValid(newPosition)) {
      position = newPosition; // עדכון המיקום החדש
      rotationState = (rotationState + 1) % 4; // עדכון מצב הסיבוב הבא
    }
  }

  bool piecePositionIsValid(List<int> piecePosition) {
    for (int pos in piecePosition) {
      int row = (pos / rowLength).floor();
      int col = pos % rowLength;
      if (row < 0 ||
          col < 0 ||
          col >= rowLength ||
          gameBoard[row][col] != null) 
        return false;  
    }
    return true;
  }
}
