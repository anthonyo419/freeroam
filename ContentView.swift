import SwiftUI

struct ContentView: View {
    @StateObject private var game = TicTacToeGame()

    var statusText: String {
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
        VStack(spacing: 24) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(statusText)
                .font(.title2)
                .foregroundColor(game.result == nil ? .primary : .accentColor)
                .animation(.default, value: statusText)

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
                Label("Reset Game", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct CellView: View {
    let symbol: String?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .aspectRatio(1, contentMode: .fit)

            if let symbol = symbol {
                Text(symbol)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(symbol == "X" ? .blue : .red)
                    .transition(.scale)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}