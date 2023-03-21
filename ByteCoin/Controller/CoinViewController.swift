import UIKit

class CoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var coinManager = CoinManager()
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        pickerData = coinManager.currencyArray
        coinManager.getCoin(currency: valueLabel.text!)
        coinManager.delegate = self
        coinManager.getCoin(currency: valueLabel.text!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoin(currency: pickerData[row])
    }
    
}
    
    
    //MARK: - CoinManagerDelegate
    
    extension CoinViewController: CoinManagerDelegate {
        
        func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
            DispatchQueue.main.sync {
                valueLabel.text = coin.asset_id_quote
                print(coin.asset_id_quote)
                coinLabel.text = String(format: "%.0f", coin.rate)
            }
        }
        
        func didFailwithError(error: Error) {
            print(error)
        }
        
    }
