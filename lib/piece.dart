import 'package:flutter/material.dart';
import 'package:tetris/board.dart';
import 'package:tetris/values.dart';
import 'dart:ui';

class Piece {
  //type of piece
  Tetromino type;

  Piece({required this.type});

  //list of integer
  List<int> position = [];

  // color of tetris piece
  Color get color {
    return tetrominoColors[type] ?? const Color(0xFFFFFFFF);
  }

  //generate integer

  void intializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-26, -16, -7, -6];
        break;
      case Tetromino.I:
        position = [-7, -6, -5, -4];
        break;
      case Tetromino.O:
        position = [-16, -15, -6, -5];
        break;
      case Tetromino.S:
        position = [-16, -15, -7, -6];
        break;
      case Tetromino.T:
        position = [-26, -16, -15, -6];
        break;
      case Tetromino.Z:
        position = [-16, -15, -5, -4];
        break;
      default:
    }
  }

  //move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  //rotate piece
  int rotationState = 1;
  void rotatePiece() {
    List<int> newPosition = [];

    //rotate the piece based on its type

    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            //get the new position
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[1] + rowLength,
              position[1] + rowLength + 1
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          o
          o
          o o
          */
            //get the new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /* 
         o o o
         o 
          */
            //get the new position
            newPosition = [
              position[1] - rowLength - 1,
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /* 
         o o
           o
          o
          */
            //get the new position
            newPosition = [
              position[2] - rowLength + 1,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            //get the new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            //get the new position
            newPosition = [
              position[1] - rowLength - 1,
              position[1] - 1,
              position[1],
              position[1] + 1
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            //get the new position
            newPosition = [
              position[2] - rowLength,
              position[2] - rowLength + 1,
              position[2],
              position[2] + rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            //get the new position
            newPosition = [
              position[2] - 1,
              position[2],
              position[2] + 1,
              position[2] + rowLength + 1,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            //get the new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            //get the new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            //get the new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            //get the new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.S:
        switch (rotationState) {
          case 0:
            //get the new position
            newPosition = [
              position[2] - rowLength,
              position[2] - rowLength + 1,
              position[2],
              position[2] - 1
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            //get the new position
            newPosition = [
              position[3] - rowLength,
              position[3],
              position[3] + 1,
              position[3] + rowLength + 1,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            //get the new position
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            //get the new position
            newPosition = [
              position[0] - rowLength - 1,
              position[0] - 1,
              position[0],
              position[0] + rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.T:
        switch (rotationState) {
          case 0:
            //get the new position
            newPosition = [
              position[0],
              position[2],
              position[3],
              position[2] + rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            //get the new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[2],
              position[3],
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            //get the new position
            newPosition = [
              position[1] - rowLength,
              position[0],
              position[1],
              position[3],
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            //get the new position
            newPosition = [
              position[0],
              position[1],
              position[2],
              position[2] + 1,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            //get the new position
            newPosition = [
              position[1] - rowLength - 1,
              position[1] - rowLength,
              position[1],
              position[2],
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            //get the new position
            newPosition = [
              position[1] + 1,
              position[2],
              position[3],
              position[2] + rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            //get the new position
            newPosition = [
              position[1] - rowLength - 1,
              position[1] - rowLength,
              position[1],
              position[2],
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            //get the new position
            newPosition = [
              position[1] + 1,
              position[2],
              position[3],
              position[2] + rowLength,
            ];
            //update position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

        break;

      default:
    }
  }

  //check if valid position
  bool positionIsValid(int position) {
    //get the row and col of pos
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    //if the position is taken, return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }

    // else position is valid so return true
    else {
      return true;
    }
  }

  //check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      //return false if any position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      //get the col of position
      int col = pos % rowLength;

      //check if last or first column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }

      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // if there is a piece in the first and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}
