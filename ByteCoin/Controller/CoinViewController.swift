import UIKit

class CoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinRate: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var coinManager = CoinManager()
    var pickerData1 = [String]()
    var pickerData0 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        pickerData1 = coinManager.currencyArray
        pickerData0 = coinManager.listOfCoin
        coinManager.delegate = self
        coinLabel.text = pickerData0.first
        valueLabel.text = pickerData1.first
        coinManager.getCoin(currencyCoin: pickerData0.first!, currency: pickerData1.first!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerData0.count
        } else {
            return pickerData1.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerData0[row]
        } else {
            return pickerData1[row]
        }    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(0)
        let coinLabel1 = pickerView.selectedRow(inComponent: 0)
        let valueLabel1 = pickerView.selectedRow(inComponent: 1)
        let coin = pickerData0[coinLabel1]
        let value = pickerData1[valueLabel1]
        coinLabel.text = coin
        valueLabel.text = value
        coinManager.getCoin(currencyCoin: coin, currency: value)
    }
}
    
    
    //MARK: - CoinManagerDelegate
    
    extension CoinViewController: CoinManagerDelegate {
        
        func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
            DispatchQueue.main.sync {
                valueLabel.text = coin.asset_id_quote
                print(coin.asset_id_quote)
                coinRate.text = String(format: "%.1f", coin.rate)
            }
        }
        
        func didFailwithError(error: Error) {
            print(error)
        }
    }
