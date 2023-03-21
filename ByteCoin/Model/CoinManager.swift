import Foundation

protocol CoinManagerDelegate {
    func didFailwithError(error: Error)
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "590224E5-107C-46F8-85D1-301D0854275A"
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let listOfCoin = ["$PAC","1000SHIB","1EARTH","1ECO","1INCH","1INCH3L","1INCH3S","1INCH5L","1INCH5S","1SOL",]
    
    var delegate: CoinManagerDelegate?
    
    func getCoin(currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailwithError(error: error!)
                    return
                }
                if let safeDate = data {
                    if let coin = self.parseJSON(coinDate: safeDate) {
                        delegate?.didUpdateCoin(self,coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(coinDate: Data) -> CoinModel? {
        let decodec = JSONDecoder()
        do {
            let decodedDate = try decodec.decode(CoinDate.self, from: coinDate)
            let assetIdQuote = decodedDate.asset_id_quote
            let rate = decodedDate.rate
            
            let coin = CoinModel(asset_id_quote: assetIdQuote, rate: rate)
            return coin
        } catch {
            delegate?.didFailwithError(error: error)
            return nil
        }
    }
}
