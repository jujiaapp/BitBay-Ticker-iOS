import Firebase

struct AnalyticsService {
    
    static let shared = AnalyticsService()
    
    private let isTrackingEnabled: Bool = false
    private let shouldPrintConsoleLog: Bool = true
    
    init() {
        FirebaseApp.configure()
    }
    
    // MARK: - States
    
    func trackAddTickerView() {
        track(name: "Add_Ticker_View")
    }
    
    func trackTickersView() {
        track(name: "Tickers_View")
    }
    
    func trackTickerDetailsView(parameters: [String: String]) {
        track(name: "Ticker_Details_View", parameters: parameters)
    }
    
    func trackEditTickersView() { // TODO: Invoke this method at a proper place
        track(name: "Edit_Tickers_View")
    }
    
    func trackRequestedRatingView() { // TODO: Invoke this method at a proper place
        track(name: "Requested_Rating_View")
    }
    
    // MARK: - Actions
    
    func trackAddedTicker(parameters: [String: String]) { // TODO: Invoke this method at a proper place
        track(name: "Added_Ticker", parameters: parameters)
    }
    
    func trackRemovedTicker(parameters: [String: String]) { // TODO: Invoke this method at a proper place
        track(name: "Removed_Ticker", parameters: parameters)
    }
    
    func trackRefreshedTickers(parameters: [String: String]) { // TODO: Invoke this method at a proper place
        track(name: "Refreshed_Tickers", parameters: parameters)
    }
    
    // MARK: - Tracking
    
    private func track(name: String, parameters: [String: String]? = nil) {
        trackIfEnabled(name: name, parameters: parameters)
        printConsoleLogIfEnabled(name: name, parameters: parameters)
    }
    
    private func trackIfEnabled(name: String, parameters: [String: String]? = nil) {
        guard isTrackingEnabled else { return }
        
        Analytics.logEvent(name, parameters: parameters)
    }
    
    private func printConsoleLogIfEnabled(name: String, parameters: [String: String]? = nil) {
        guard shouldPrintConsoleLog else { return }
        
        var description = "👣 [TRACKED] \"\(name)\""
        
        if let parameters = parameters {
            description += " with parameters: \(String(describing: parameters))"
        }
        
        print(description)
    }
    
}
