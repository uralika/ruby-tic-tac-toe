ROWS = {'1'=> 0, '2' => 1, '3' => 2}
COLUMNS = {'A' => 0, 'B' => 1, 'C' => 2}
ODD = 'X'
EVEN = 'O'

$board_array = [[' ',' ',' '], [' ',' ',' '], [' ',' ',' ']]
$moves_array = []

$col_keys = COLUMNS.keys
$row_keys = ROWS.keys
# Store an array of all available moves
for c in $col_keys do
	for r in $row_keys do
		$moves_array.push(c + r)
	end
end

def display_board
	divider = '   +---+---+---+'

	puts "     #{$col_keys[0]}   #{$col_keys[1]}   #{$col_keys[2]}  "
	puts divider
	puts "#{$row_keys[0]}  | #{$board_array[0][0]} | #{$board_array[0][1]} | #{$board_array[0][2]} |"
	puts divider
	puts "#{$row_keys[1]}  | #{$board_array[1][0]} | #{$board_array[1][1]} | #{$board_array[1][2]} |"
	puts divider
	puts "#{$row_keys[2]}  | #{$board_array[2][0]} | #{$board_array[2][1]} | #{$board_array[2][2]} |"
	puts divider
end

def decide_player
	puts "Which player do you want to be? #{ODD} or #{EVEN}? "
	player = gets.strip.upcase

	unless [ODD, EVEN].include?(player)
		puts 'Invalid entry.'
		player = decide_player
	end

	return player
end

def make_move(row, col, val)
	$board_array[row][col] = val
end

def get_move
	puts 'Where do you want to move?'
	move = gets.strip.upcase.split('')

	unless valid_move(move)
		puts "Invalid move. Valid moves: #{$moves_array.join(', ')}."
		move = get_move
	end

	return move
end

def valid_move(move)
	if move.length != 2 || !(move.all? {|val| val.instance_of? String})
		return false
	end

	if !ROWS[move[1]] || !COLUMNS[move[0]]
		return false
	end

	if !$board_array[ROWS[move[1]]][COLUMNS[move[0]]].strip.empty?
		return false
	end

	return move
end

def get_random_move
	return $moves_array.sample.split('')
end

def winner(moves)
	if moves < 5
		return false
	end

	player_to_check = moves % 2 === 1 ? ODD : EVEN

	# Winning conditions
	if ( ($board_array[0][0] === $board_array[0][1] && $board_array[0][1] === $board_array[0][2] && $board_array[0][2] === player_to_check) ||
		($board_array[1][0] === $board_array[1][1] && $board_array[1][1] === $board_array[1][2] && $board_array[1][2] === player_to_check) ||
		($board_array[2][0] === $board_array[2][1] && $board_array[2][1] === $board_array[2][2] && $board_array[2][2] === player_to_check) ||
		($board_array[0][0] === $board_array[1][0] && $board_array[1][0] === $board_array[2][0] && $board_array[2][0] === player_to_check) ||
		($board_array[0][1] === $board_array[1][1] && $board_array[1][1] === $board_array[2][1] && $board_array[2][1] === player_to_check) ||
		($board_array[0][2] === $board_array[1][2] && $board_array[1][2] === $board_array[2][2] && $board_array[2][2] === player_to_check) ||
		($board_array[0][0] === $board_array[1][1] && $board_array[1][1] === $board_array[2][2] && $board_array[2][2] === player_to_check) ||
		($board_array[0][2] === $board_array[1][1] && $board_array[1][1] === $board_array[2][0] && $board_array[2][0] === player_to_check) )
		return player_to_check
	else
		return false
	end
end

# Initial game setup
moves_count = 1
moves_total = $board_array.length ** 2

display_board
player = decide_player

# Make the computer move first if it is 'X'
if player === EVEN
	move = get_random_move
	make_move(ROWS[move[1]], COLUMNS[move[0]], ODD)
	display_board
	moves_count += 1
	$moves_array.delete(move.join)
end

# Main game loop
loop do
	# Player move
	move = get_move
	make_move(ROWS[move[1]], COLUMNS[move[0]], player)

	if winner(moves_count)
		display_board
		puts winner(moves_count) + ' won!'
		break
	end

	if moves_count >= moves_total
		display_board
		puts 'This is a draw!'
		break
	end

	moves_count += 1
	$moves_array.delete(move.join)

	player === ODD ? player = EVEN : player = ODD

	# Computer move
	move = get_random_move
	make_move(ROWS[move[1]], COLUMNS[move[0]], player)
	display_board

	if winner(moves_count)
		puts winner(moves_count) + ' won!'
		break
	end

	if moves_count >= moves_total
		puts 'This is a draw!'
		break
	end

	moves_count += 1
	$moves_array.delete(move.join)

	player === ODD ? player = EVEN : player = ODD
end
