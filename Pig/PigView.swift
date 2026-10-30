//
//  PigView.swift
//  Pig
//
//  WHAT THIS GAME DOES NOW
//  Pig is a dice game for two players who share one laptop.
//  On your turn, roll the die as many times as you like.
//  Each roll adds to your turn total.
//  Roll a 1 and you lose your turn total, and your turn is over.
//  Click Hold to bank your turn total into your score and end your turn.
//
//  WHAT IT DOES NOT DO YET
//  Nobody can win! The scores just keep going up.
//  In the real game, the first player to reach 100 points wins.
//

import SwiftUI

// Each player has their own colour.
// TRY: Change these two colours. Try Color.purple, Color.green or Color.pink.
let playerOneColor: Color = Color.blue
let playerTwoColor: Color = Color.orange

// The game itself: what it remembers, what it shows on the screen,
// and what it does when you click a button.
struct PigView: View {

    // MARK: - Stored properties

        // Each @State variable is something the game remembers.
        // When one of them changes, the screen updates by itself.

        // The points each player has banked. Banked points are safe.
        @State var playerOneScore: Int = 0
        @State var playerTwoScore: Int = 0

        // The points collected so far on this turn.
        // They are not safe until the player clicks Hold.
        @State var turnTotal: Int = 0

        // Whose turn it is: 1 or 2.
        @State var currentPlayer: Int = 1

        // The colour of whoever's turn it is.
        @State var turnColor: Color = playerOneColor

        // The name of the SF Symbol that shows the die.
        @State var dieSymbol1: String = "questionmark.square.fill"
        @State var dieSymbol2: String = "questionmark.square.fill"

        // A message that tells the players what just happened.
        @State var message: String = "Player 1 goes first. Click Roll to start."

        // State-Variablen für Startseite, Spielmodus, Sieg & KI
        @State private var isGameStarted: Bool = false
        @State private var isVsComputer: Bool = false
        @State private var winningScore: Int = 100
        @State private var gameOver: Bool = false
        @State private var winnerName: String = ""
        @State private var isComputerThinking: Bool = false

        // MARK: - Computed properties

    var body: some View {
            Group {
                if !isGameStarted {
                    startView
                } else if gameOver {
                    endView
                } else {
                    gameView
                }
            }
            .fontDesign(.rounded)
            // How big the game's window is on the Mac. It can be made taller or wider.
            .frame(minWidth: 480, minHeight: 680)
        }

        // MARK: - Start View (Startseite)

        var startView: some View {
            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 8) {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.tint)
                    Text("Dice Game")
                        .font(.largeTitle)
                        .bold()
                    Text("Be the first getting \(winningScore) Points!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 8) {
                                Text("Winning Score:")
                                    .font(.headline)
                                
                                Picker("Zielpunkte", selection: $winningScore) {
                                    Text("100 Points").tag(100)
                                    Text("200 Points").tag(200)
                                    Text("500 Points").tag(500)
                                    Text("1000 Points").tag(1000)
                                }
                                .pickerStyle(.segmented)
                                .frame(maxWidth: 320)
                            }
                            .padding(.vertical, 8)

                VStack(spacing: 16) {
                    Button(action: {
                        isVsComputer = false
                        startNewGame()
                        isGameStarted = true
                    }) {
                        Label("Pass & Play (2 Players)", systemImage: "person.2.fill")
                            .frame(maxWidth: 280)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button(action: {
                        isVsComputer = true
                        startNewGame()
                        isGameStarted = true
                    }) {
                        Label("Against Computer", systemImage: "cpu")
                            .frame(maxWidth: 280)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }

                Spacer()
            }
            .padding(32)
        }
    
    var endView: some View {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.yellow)

                Text("Game over!")
                    .font(.largeTitle)
                    .bold()

                Text("\(winnerName) has won the game!")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                VStack(spacing: 16) {
                    Button(action: {
                        startNewGame()
                    }) {
                        Label("Play again", systemImage: "arrow.clockwise")
                            .frame(maxWidth: 280)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button(action: {
                        isGameStarted = false
                    }) {
                        Label("Mainmenu", systemImage: "house.fill")
                            .frame(maxWidth: 280)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }

                Spacer()
            }
            .padding(32)
        }

        // MARK: - Main Game View

        var gameView: some View {
            VStack(spacing: 12) {

                // The title at the top of the screen.
                HStack {
                    Image(systemName: "dice.fill")
                    Text("Pig")
                }
                .font(.largeTitle)
                .bold()

                // The scoreboard: one card for each player.
                HStack(spacing: 16) {
                    VStack {
                        Text("Player 1")
                            .font(.headline)
                        Text("\(playerOneScore)")
                            .font(.system(size: 48, weight: .bold))
                            .monospacedDigit()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(playerOneColor.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack {
                        Text(isVsComputer ? "Computer" : "Player 2")
                            .font(.headline)
                        Text("\(playerTwoScore)")
                            .font(.system(size: 48, weight: .bold))
                            .monospacedDigit()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(playerTwoColor.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                Spacer()

                // Whose turn is it?
                Text(currentPlayer == 2 && isVsComputer ? "Computer's turn" : "Player \(currentPlayer), your turn")
                    .font(.title)
                    .bold()
                    .foregroundStyle(turnColor)

                // The die.
                // TRY: Change the size of the die from 120 to something bigger or smaller.
                HStack(spacing: 20) {
                    Image(systemName: dieSymbol1)
                        .font(.system(size: 100))
                        .foregroundStyle(turnColor)

                    Image(systemName: dieSymbol2)
                        .font(.system(size: 100))
                        .foregroundStyle(turnColor)
                }

                Text("Turn total: \(turnTotal)")
                    .font(.title2)
                    .bold()
                    .monospacedDigit()

                Text(message)
                    .font(.headline)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 44)

                Spacer()

                // The two buttons a player uses on their turn.
                // The code inside the braces runs when that button is clicked.
                HStack(spacing: 16) {
                    Button("Roll", systemImage: "dice") {
                        rollDie()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Hold", systemImage: "hand.raised.fill") {
                        hold()
                    }
                    .buttonStyle(.bordered)
                }
                .font(.title2)
                .bold()
                .controlSize(.large)
                .tint(turnColor)
                .disabled(gameOver || (currentPlayer == 2 && isVsComputer) || isComputerThinking)

                HStack(spacing: 20) {
                    Button("New Game") {
                        startNewGame()
                    }

                    Button("Mainmenu") {
                        isGameStarted = false
                    }
                }
                .padding(.top, 8)
            }
            .padding(32)
            .alert("Game over!", isPresented: $gameOver) {
                Button("New game") {
                    startNewGame()
                }
                Button("Mainmenu") {
                    isGameStarted = false
                }
            } message: {
                Text("\(winnerName) has won the game!")
            }
        }

        // MARK: - Functions

        // Rolls the die once for the current player.
        func rollDie() {

            // Pick a random whole number from 1 to 6, just like a real die.
            let rolldie1: Int = Int.random(in: 1...6)

            // Show the matching die face. For a roll of 4, the symbol is "die.face.4.fill".
            dieSymbol1 = "die.face.\(rolldie1).fill"

            let rolldie2: Int = Int.random(in: 1...6)

            dieSymbol2 = "die.face.\(rolldie2).fill"

            if rolldie1 == 1 || rolldie2 == 1 {
                // A 1 wipes out the turn total and ends the turn.
                let name = (currentPlayer == 2 && isVsComputer) ? "Computer" : "Player \(currentPlayer)"
                message = "Oh no, a 1! \(name) loses \(turnTotal) points."
                turnTotal = 0
                switchPlayer()
            } else {
                // Any other roll is added to the turn total.
                var pointsThisRoll = rolldie1 + rolldie2
                
                // Pasch-Regel: Doppelter Wert bei gleichen Zahlen
                if rolldie1 == rolldie2 {
                    pointsThisRoll *= 2
                    message = "Pasch! Double Points! You rolled double \(rolldie1)."
                } else {
                    message = "You rolled a \(rolldie1) and \(rolldie2). Roll again, or hold?"
                }

                turnTotal += pointsThisRoll
                
                // Prüfen, ob der Spieler zusammen mit den geparkten Punkten schon gewinnt
                let currentScore = currentPlayer == 1 ? playerOneScore : playerTwoScore
                if currentScore + turnTotal >= winningScore {
                    hold()
                }
            }
        }

        // Banks the turn total into the current player's score, then ends the turn.
        func hold() {
            if currentPlayer == 1 {
                playerOneScore += turnTotal
            } else {
                playerTwoScore += turnTotal
            }
            
            let name = (currentPlayer == 2 && isVsComputer) ? "Computer" : "Player \(currentPlayer)"
            message = "\(name) banked \(turnTotal) points."
            turnTotal = 0

            // Prüfen auf Gewinn
            if playerOneScore >= winningScore {
                winnerName = "Player 1"
                gameOver = true
                return
            } else if playerTwoScore >= winningScore {
                winnerName = isVsComputer ? "Computer" : "Player 2"
                gameOver = true
                return
            }

            switchPlayer()
        }

        // Passes the turn to the other player.
        func switchPlayer() {
            if currentPlayer == 1 {
                currentPlayer = 2
                turnColor = playerTwoColor
                
                if isVsComputer && !gameOver {
                    takeComputerTurn()
                }
            } else {
                currentPlayer = 1
                turnColor = playerOneColor
            }
        }

        // Sets everything back to the way it was at the start.
        func startNewGame() {
            playerOneScore = 0
            playerTwoScore = 0
            turnTotal = 0
            currentPlayer = 1
            turnColor = playerOneColor
            dieSymbol1 = "questionmark.square.fill"
            dieSymbol2 = "questionmark.square.fill"
            message = "Player 1 goes first. Click Roll to start."
            gameOver = false
            winnerName = ""
            isComputerThinking = false
        }

        // MARK: - Computer Logic

        func takeComputerTurn() {
            isComputerThinking = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                guard currentPlayer == 2, !gameOver else {
                    isComputerThinking = false
                    return
                }

                rollDie()

                // Wenn während des Wurfes eine 1 gewürfelt wurde, ist der Zug bereits beendet
                if currentPlayer != 2 {
                    isComputerThinking = false
                    return
                }

                // KI-Strategie: Halten bei >= 15 Punkten oder wenn der Gesamtpunktestand reicht
                if turnTotal >= 15 || (playerTwoScore + turnTotal >= winningScore) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        hold()
                        isComputerThinking = false
                    }
                } else {
                    // Erneut würfeln
                    takeComputerTurn()
                }
            }
        }
}

#Preview {
    PigView()
}
