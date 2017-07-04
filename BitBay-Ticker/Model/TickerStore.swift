import Foundation
import RxSwift

final class TickerStore {
    
    static let shared = TickerStore()
    
    private let disposeBag = DisposeBag()
    
    var userTickers = Variable<[Ticker]>([])
    
    private let allAvailableTickersNames: [Ticker.Name] = [
        .btcpln, .ethpln, .ltcpln, .lskpln,
        .btceur, .etheur, .ltceur, .lskeur,
        .btcusd, .ethusd, .ltcusd, .lskusd,
        .ltcbtc, .ethbtc, .lskbtc
    ]
    
    func refreshTickers() {
        Observable
            .zip(
                userTickers.value.map { (ticker) in
                    return TickerFactory.makeObservableTicker(named: ticker.name)
                }
            )
            .subscribe(
                onNext: { [weak self] (tickers) in
                    self?.userTickers.value = tickers
                }
            )
            .disposed(by: disposeBag)
    }
    
    var availableTickersNamesToAdd: [Ticker.Name] {
        let userTickerNames = userTickers.value.map {
            return $0.name
        }
        
        let duplicates = allAvailableTickersNames.filter(userTickerNames.contains)
        
        return allAvailableTickersNames.filter {
            return !duplicates.contains($0)
        }
    }
    
    func addTicker(named tickerName: Ticker.Name) {
        let ticker = Ticker(name: tickerName, jsonDictionary: nil)
        
        userTickers.value.append(ticker)
    }
    
    // MARK: - Saving / Loading Data
    
    private let userDataPlistName = "user_data"
    
    private var userDataDictionary: [String: Any] {
        let allUserTickersDictionary = userTickers.value.map {
            return $0.dictionary
        }
        
        return [
            "tickers": allUserTickersDictionary
        ]
    }
    
    func loadUserData() {
        let loadedUserDataDictionary = PlistFile(name: userDataPlistName).dictionary
        
        guard let allTickers = loadedUserDataDictionary?["tickers"] as? [[String: Any]] else { return }
        
        var loadedTickers = [Ticker]()
        
        allTickers.forEach {
            let loadedTicker = Ticker(fromDictionary: $0)
            loadedTickers.append(loadedTicker)
        }
        
        userTickers.value = loadedTickers
    }
    
    func saveUserData() {
        _ = PlistFile(name: userDataPlistName).save(dictionary: userDataDictionary)
    }

}