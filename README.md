# Behold! Tic Tac Toe!!
This is a VERY simple tic-tac-toe game using Godot 3.1. I wrote this some time ago and recently
refined it after Godot 3.1 was release. This game does not use a _process loop. Instead it's entirely event driven by the button clicks. This game is single player vs computer.

![alt text](https://github.com/bitbionic/tic-tac-toe-gd3/blob/master/ATT.png)

## Youtube overview
I have a Youtube overview here: https://youtu.be/2yIAXi9c2ag

## History
When I interview software engineers for a new job, I sometimes ask them to write the logic
for a tic tac toe game, assuming the UI is developed for them. Their task is to represent
the game state and check for the win / lose / tie conditions - if they knock that out of the park
we start talking about ways to code the AI, and computational complexity if we decided to change
the game to 4 in a row or 5 in a row. I thought it might be fun to do the exercise with Godot, 
and thus this project was born.

## Scoring
The board uses a simple array of buttons each of which holds a value initialized to zero.
I use the constants 1 and 10 to represent the player values X and O. Setting the board
values to 1 or 10 based upon which player selects a position makes scoring and AI pretty
easy:

```python
onready var board = [
            [$TicTacButton1, $TicTacButton2, $TicTacButton3],
            [$TicTacButton4, $TicTacButton5, $TicTacButton6],
            [$TicTacButton7, $TicTacButton8, $TicTacButton9], 
            ]
.
.

# We use these player values for two purposes
# To distiguish the "activePlayer", and to make
# scoring easy.
const X = 1
const O = 10  # The computer
```
To check for win conditions we can simply sum the rows, cols or diagonals. If the sum is
3 * X, X wins .. if the sum is 3 * O, then of course O wins.

AI logic is as follows:
  * Check for a winning move (do any row,col,diag sums == 20 or 2*O)
  * If no winning move, check for a block (prevent the player from winning if they have a score of 2 in a row, column or diagonal.
  * If neither of the above, just select a random square.
  
