import SwiftUI

struct ContentView: View {
    @StateObject private var game = TicTacToeGame()

    var statusMessage: String {
        switch game.result {
        case .win(let player):
            return "Player \(player.symbol) wins! 🎉"
        case .draw:
            return "It's a draw!"
        case nil:
            return "Player \(game.currentPlayer.symbol)'s turn"
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack(spacing: 8) {
                if game.isGameOver {
                    Image(systemName: "checkmark.seal.fill")
                }
                Text(statusMessage)
                    .font(.title2)
                    .foregroundColor(game.isGameOver ? .red : .primary)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(0..<9, id: \.self) { index in
                    CellView(symbol: game.board[index]?.symbol)
                        .onTapGesture {
                            game.makeMove(at: index)
                        }
                }
            }
            .padding(.horizontal)

            Button(action: { game.resetGame() }) {
                Text("Reset")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct CellView: View {
    let symbol: String?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
                .aspectRatio(1, contentMode: .fit)

            if let symbol = symbol {
                Text(symbol)
                    .font(.system(size: 48, weight: symbol == "X" ? .bold : .regular))
                    .foregroundColor(symbol == "X" ? .blue : .red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}