//
//  ViewController.swift
//  ByteCoin
//
//  Created by Maksim on 21.06.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    // MARK : - UI
    private lazy var byteCoinLabel: UILabel = {
        let element = UILabel()
        element.text = "ByteCoin"
        element.font = .systemFont(ofSize: 70, weight: .light)
        return element
    }()
    
    private lazy var firstStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 10
        element.alignment = .center
        element.backgroundColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 0.5)
        element.layer.cornerRadius = 40
        return element
    }()
    
    private lazy var bitcoinIconView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(systemName: "bitcoinsign.circle")
        element.tintColor = .black
        return element
    }()
    
    private lazy var bitcoinLabel: UILabel = {
        let element = UILabel()
        element.textAlignment = .left
        element.font = .systemFont(ofSize: 30, weight: .regular)
        element.textAlignment = .right
        element.setContentHuggingPriority(.defaultLow, for: .horizontal)
        element.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return element
    }()
    
    private lazy var currencyLabel: UILabel = {
        let element = UILabel()
        //element.text = "USD"
        element.font = .systemFont(ofSize: 30, weight: .regular)
        return element
    }()
    
    private lazy var currencyPicker: UIPickerView = {
        let element = UIPickerView()
        return element
    }()

    // MARK: - Private properties
    private var coinManager = CoinManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.76, green: 0.88, blue: 0.77, alpha: 1.00)
        view.addSubview(byteCoinLabel)
        view.addSubview(firstStackView)
        view.addSubview(currencyPicker)
        
        firstStackView.addArrangedSubview(bitcoinIconView)
        firstStackView.addArrangedSubview(bitcoinLabel)
        firstStackView.addArrangedSubview(currencyLabel)
    }
}

// MARK: - Setup constraints
extension ViewController {
    private func setupConstraints() {
        byteCoinLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        firstStackView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalTo(byteCoinLabel).inset(100)
            make.left.right.equalToSuperview().inset(30)
        }
        
        bitcoinIconView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }

        currencyLabel.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        currencyPicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String) {
        
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return coinManager.currencyArray.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return coinManager.currencyArray[row]
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let selectedCurrency = coinManager.currencyArray[row]
          coinManager.getCoinPrice(for: selectedCurrency)
      }
}
