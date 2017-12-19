extends Control

onready var board = [ 	[$Container/TicTacButton1, $Container/TicTacButton2, $Container/TicTacButton3],
						[$Container/TicTacButton4, $Container/TicTacButton5, $Container/TicTacButton6],
						[$Container/TicTacButton7, $Container/TicTacButton8, $Container/TicTacButton9], ]

onready var winDialog = $WinDialog

const X = 1
const O = 10

var activePlayer = X
var currentRound = 0
var winner = false

func _ready():
	for row in board:
		for btn in row:
			btn.connect( "custom_pressed", self, "onTicTacBtnPressed" )
	
	var cancelBtn = winDialog.get_cancel()
	cancelBtn.set_text("Quit")
	cancelBtn.connect("pressed", self, "onQuit")
	winDialog.get_ok().set_text("Play Again!")
#	winDialog.show()

func clearBoard():
	currentRound = 0
	winner = false
	activePlayer = X
	# Resets the board
	for row in board:
		for btn in row:
			btn.reset()

func placeMark( row, col, player ):
	if player == X:
		board[row][col].setX(X)
		activePlayer = O
	else:
		board[row][col].setO(O)
		activePlayer = X
	
	currentRound += 1
	
	checkWin()
		
	if currentRound == 9:
		winDialog.window_title = "Draw!!"
		winDialog.dialog_text = "The game was a draw!"
		winDialog.show()
	elif activePlayer == O and not winner:
		aiPicPoint()

func sumRow( rowNum ):
	# Returns the sum of the supplied row
	# Passing an invalid row returns 0
	var sum = 0
	for btn in board[rowNum]:
		sum += btn.value
	return sum

func sumCol( colNum):
	# Returns the sum of the supplied column
	# Passing an invalid column returns 0
	var sum = 0
	for row in board:
		sum += row[ colNum ].value
	return sum

func sumDiag_1():
	# Returns the sum of the diagonal from (0,0) to (2,2)
	var sum = 0
	for idx in range(3):
		sum += board[idx][idx].value
		
	return sum

func sumDiag_2():
	# Returns the sum of the diagonal from (0,2) to (2,0)
	var sum = 0 
	for idx in range(3):
		sum += board[idx][2-idx].value
	return sum

func showWinDialog( title, text ):
	winner = true
	winDialog.window_title = title
	winDialog.dialog_text = text
	winDialog.show()

func checkWin():
	var row = 0
	var col = 0
	var d1 = 0
	var d2 = 0
	
	for idx in range(3):
		row = sumRow(idx)
		print( "Row %d Sum: %d" % [idx,row] )
		if row == 3:
			showWinDialog( "Player X Wins!", "Player X Wins in Row " + str(idx+1) )
		elif row == 30:
			showWinDialog( "Player O Wins!", "Player O Wins in Row " + str(idx+1) )
			
		col = sumCol(idx)
		print( "Col %d Sum: %d" % [idx, col] )
		if col == 3:
			showWinDialog( "Player X Wins!", "Player X Wins in Column " + str(idx+1) )
		elif col == 30:
			showWinDialog( "Player O Wins!", "Player O Wins in Column " + str(idx+1) )
		
	d1 = sumDiag_1()
	d2 = sumDiag_2()
	print( "Diag 1 : %d" % d1)
	if d1 == 3 or d2 == 3:
		showWinDialog( "Player X Wins!", "Player X Wins in the diagonal" )
	elif d1 == 30 or d2 == 30:
		showWinDialog( "Player O Wins!", "Player O Wins in the diagonal" )
	print( "Diag 2 : %d" % sumDiag_2() )
	
func onTicTacBtnPressed( button ):
	# When a TicTacButton is pressed, it fires a signal
	# We've registered to "respond" to that signal here.
	print("Pressed (%d, %d)" % [button.row, button.col] )
	
	if board[button.row][button.col].value != 0:
		print("Already filled")
	else:
		placeMark( button.row, button.col, activePlayer )
		

func aiFillRow( row ):
	for column in range(3):
		if board[ row ][ column ].value == 0:
			placeMark( row, column, activePlayer )

func aiFillCol( col ):
	for row in range(3):
		if board[ row ][ col ].value == 0:
			placeMark( row, col, activePlayer )

func aiFillDiag_1():
	for idx in range(3):
		if board[idx][idx].value == 0:
			placeMark( idx, idx, activePlayer )

func aiFillDiag_2():
	for idx in range(3):
		if board[idx][2-idx].value == 0:
			placeMark( idx, 2-idx, activePlayer )

func aiPicWinningFill():
	# Try to win first by checking for any row, col or diag
	# that equals 20, meaning we can fill it and win the game
	for idx in range(3):
		if sumRow( idx ) == 20:
			# We can win by filling in the row
			aiFillRow( idx )
			return true
		elif sumCol( idx ) == 20:
			# we can win by filling in the column
			aiFillCol( idx )
			return true
	if sumDiag_1() == 20:
		# we can win by filling in the diagonal
		aiFillDiag_1()
		return true
	elif sumDiag_2() == 20:
		# we can win by filling in the diagonal
		aiFillDiag_2()
		return true
		
	return false

func aiBlock():
	for idx in range(3):
		if sumRow( idx ) == 2:
			# Need to block
			aiFillRow( idx )
			return true
		elif sumCol( idx ) == 2:
			aiFillCol( idx )
			return true
	if sumDiag_1() == 2:
		aiFillDiag_1()
		return true
	elif sumDiag_2() == 2:
		aiFillDiag_2()
		return true
	
	false

func aiPicPoint():
	# Checks for obvious win
	# Checks for obvious block
	# Then just chooses random
	if not aiPicWinningFill():
		if not aiBlock():
			var row = randi() % 3
			var col = randi() % 3
			var valid = false
			while not valid:
				if board[row][col].value == 0:
					valid = true
				else:
					row = randi() % 3
					col = randi() % 3
				
			placeMark( row, col, activePlayer )

func onPlayAgain():
	clearBoard()

func onQuit():
	get_tree().quit()