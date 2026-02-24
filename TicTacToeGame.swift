import Foundation

/// Represents a player in the Tic Tac Toe game.
enum Player {
    case x, o

    var symbol: String {
        switch self {
        case .x: return "X"
        case .o: return "O"
        }
    }
}

/// Represents the result of a completed game.
enum GameResult {
    case win(Player)
    case draw
}

/// Core game logic for Tic Tac Toe, designed to be used with a SwiftUI frontend.
class TicTacToeGame: ObservableObject {
    /// The 3x3 board, where nil means the cell is empty.
    @Published private(set) var board: [Player?] = Array(repeating: nil, count: 9)

    /// The player whose turn it currently is.
    @Published private(set) var currentPlayer: Player = .x

    /// The result of the game once it has ended, or nil if still in progress.
    @Published private(set) var result: GameResult? = nil

    /// Returns true if the game is over (either won or drawn).
    var isGameOver: Bool { result != nil }

    /// Attempts to place the current player's mark at the given board index (0–8).
    /// Does nothing if the cell is already taken or the game is over.
    func makeMove(at index: Int) {
        guard index >= 0, index < 9,
              board[index] == nil,
              !isGameOver else { return }

        board[index] = currentPlayer

        if let winner = checkWinner() {
            result = .win(winner)
        } else if board.allSatisfy({ $0 != nil }) {
            result = .draw
        } else {
            currentPlayer = currentPlayer == .x ? .o : .x
        }
    }

    /// Resets the board for a new match.
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = .x
        result = nil
    }

    // MARK: - Private

    private static let winningLines: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
        [0, 4, 8], [2, 4, 6]             // diagonals
    ]

    private func checkWinner() -> Player? {
        for line in Self.winningLines {
            let marks = line.map { board[$0] }
            if marks[0] != nil, marks[0] == marks[1], marks[1] == marks[2] {
                return marks[0]
            }
        }
        return nil
    }
}
