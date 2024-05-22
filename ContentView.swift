import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TriviaViewModel()
    
    var body: some View {
        VStack {
            if viewModel.showScore {
                VStack {
                    Text("Your Score: \(viewModel.score)/\(viewModel.questions.count)")
                        .font(.largeTitle)
                        .padding()
                    
                    Button(action: {
                        viewModel.resetQuiz()
                    }) {
                        Text("Restart Quiz")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.top)
                    }
                }
            } else {
                if let question = viewModel.currentQuestion {
                    Text(question.question)
                        .font(.title)
                        .padding()
                    
                    ForEach(question.allAnswers, id: \.self) { answer in
                        Button(action: {
                            viewModel.submitAnswer(answer)
                        }) {
                            Text(answer)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                    }
                    
                    Button(action: {
                        viewModel.nextQuestion()
                    }) {
                        Text("Next Question")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.top)
                    }
                } else {
                    Text("Loading...")
                        .font(.title)
                        .padding()
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
