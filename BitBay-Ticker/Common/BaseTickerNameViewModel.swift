import Foundation

protocol BaseTickerNameViewModel {
    
    var tickerName: Ticker.Name { get }
    
    var name: String { get }
    var baseCurrency: String { get }
    var counterCurrency: String { get }
    
}

extension BaseTickerNameViewModel {
    
    var name: String {
        return "\(baseCurrency)/\(counterCurrency)"
    }
    
    var baseCurrency: String {
        return String(tickerName.rawValue.uppercased().characters.dropLast(3))
    }
    
    var counterCurrency: String {
        return String(tickerName.rawValue.uppercased().characters.dropFirst(3))
    }
    
}
