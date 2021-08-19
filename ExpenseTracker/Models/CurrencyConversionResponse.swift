// Swift toolchain version 5.0
// Running macOS version 12.0
// Created on 8/19/21.
//
// Author: Kieran Brown
//

import Combine
import Foundation
import OSLog

struct CurrencyConversionResponse: Codable {
    var amount: Double
    var rate: Double
}

struct DisplayableError: Identifiable {
    var title: String
    var message: String
    
    var id: String { title + message }
}

class CurrencyConversionManager: ObservableObject {
    @Published var response: CurrencyConversionResponse?
    @Published var currency: Currency = .usd
    @Published var fetchErrorToDisplay: DisplayableError?
    let logger = Logger(subsystem: "com.devteam.currency", category: "Currency")
    
    var cancellable: AnyCancellable?
    
    func fetchConvertedAmount(value: Double) {
        guard let requestUrl = Self.endpointURL else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.httpBody = Self.getPostString_ConvertFromUSDToEUR(value: 20.25).data(using: String.Encoding.utf8)
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: CurrencyConversionResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.currency = .usd
                    self.fetchErrorToDisplay = DisplayableError(title: "Error converting USD to EUR",
                                                                message: "Please try the operation again later.")
                    self.logger.log("\(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.response = response
            })
    }
    
    
    static let endpointURL = URL(string: "https://us-central1-winged-zodiac-315621.cloudfunctions.net/demoApi2")
    
    static func getPostString_ConvertFromUSDToEUR(value: Double) -> String {
        """
        {"amount":\(value),"to_currency":"EUR","from_currency":"USD"}
        """
    }
}
