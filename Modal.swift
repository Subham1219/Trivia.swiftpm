import Foundation
import Combine

class TriviaViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var currentQuestion: TriviaQuestion?
    @Published var score = 0
    @Published var showScore = false
    
    private var cancellable: AnyCancellable?
    
    init() {
        fetchTriviaQuestions()
    }
    
    func fetchTriviaQuestions() {
        let urlString = "https://the-trivia-api.com/v2/questions?limit=20&difficulty=medium"
        guard let url = URL(string: urlString) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TriviaQuestion].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] questions in
                self?.questions = questions
                self?.currentQuestion = self?.questions.first
            })
    }
    
    func submitAnswer(_ answer: String) {
        if let currentQuestion = currentQuestion, answer == currentQuestion.correctAnswer {
            score += 1
        }
        nextQuestion()
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            currentQuestion = questions[currentQuestionIndex]
        } else {
            currentQuestion = nil
            showScore = true
        }
    }
    
    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        showScore = false
        fetchTriviaQuestions()
    }
}
