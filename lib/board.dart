// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

//create game board

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //current tetris piece

  Piece currentPiece = Piece(type: Tetromino.L);

  //current score
  int currentScore = 0;

  //game over status
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    //start the game
    startGame();
  }

  void startGame() {
    currentPiece.intializePiece();

    //frame refresh rate
    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          //clear lines
          clearLines();

          //check landing
          checkLanding();

          //check if game is over
          if (gameOver) {
            timer.cancel();
            showGameOverDialog();
          }

          // move current piece down
          currentPiece.movePiece(Direction.down);
        });
      },
    );
  }

  // game over message

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Game Over"),
              content: Text("Your score is: $currentScore"),
              actions: [
                TextButton(
                    onPressed: () {
                      //reset the game
                      resetGame();

                      Navigator.pop(context);
                    },
                    child: Text("Play Again!!!"))
              ],
            ));
  }

  void resetGame() {
    //clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    //new game
    gameOver = false;
    currentScore = 0;

    //create a new piece
    createNewPiece();

    //start the game
    startGame();
  }

  //check for collision on future position
  //return true -> if collision
  //return false -> if no collision
  bool checkCollision(Direction direction) {
    //loop through each position of the current pos
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calculate the row and column of the current pos.
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = (currentPiece.position[i] % rowLength);

      //adjust the row and column based on direction

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }
      //check if the piece is out of bound (either too low or too far left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      if (row >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }

    //if no collision is detected, return false
    return false;
  }

  void checkLanding() {
    //if going down is occupied
    if (checkCollision(Direction.down)) {
      //mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = (currentPiece.position[i] % rowLength);

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      //once landed, create new piece
      createNewPiece();
    }
  }

  //move left
  void moveLeft() {
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  //move right
  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  //rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void createNewPiece() {
    // create a random object to generate random tetromino types

    Random rand = Random();

    //create a new piece with random type
    Tetromino randdomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randdomType);
    currentPiece.intializePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  void clearLines() {
    // step 1: Loop through each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      //step 2: Initialize a variable to track if the row is full
      bool rowIsFull = true;
      //step 3: Check if the row is full
      for (int col = 0; col < rowLength; col++) {
        // if there's an empty column, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: if the row is full, clear the row and shift rows down
      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          //copy above row to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        //step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        //step 7: Increase the Score
        currentScore++;
      }
    }
  }

  bool isGameOver() {
    //check if any column in the top row is filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    //if the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //Game Grid
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              // physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                //get row and col of each index
                int row = (index / rowLength).floor();
                int col = (index % rowLength);

                // current piece
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                  );
                }

                //landed pieces

                else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                      color: tetrominoColors[tetrominoType]);
                }

                //blank pixel
                else {
                  return Pixel(
                    color: Colors.grey[900],
                  );
                }
              },
            ),
          ),

          //SCORE
          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white),
          ),

          //Game Controls

          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios)),
                IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: Icon(Icons.rotate_right)),
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
