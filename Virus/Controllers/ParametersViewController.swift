//
//  ParametersViewController.swift
//  Virus
//
//  Created by Евгений Житников on 05.05.2023.
//

import UIKit

class ParametersViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var groupSizeLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Введите количество человек в моделируемой группе (чел):"
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var groupSizeTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "От 1 до 1000 человек"
        view.keyboardType = .default
        view.borderStyle = .roundedRect
        view.delegate = self
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        return view
    }()
    
    private lazy var infectionFactorLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Введите количество человек, которое может быть заражено при контакте (чел):"
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var infectionFactorTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "От 1 до 8 человек"
        view.keyboardType = .default
        view.borderStyle = .roundedRect
        view.delegate = self
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        return view
    }()
    
    private lazy var infectionPeriodLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Скорость передачи вируса от человека человеку (сек):"
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var infectionPeriodTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "От 1 до 5 секунд"
        view.keyboardType = .default
        view.borderStyle = .roundedRect
        view.delegate = self
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        return view
    }()
    
    private lazy var startSimulationButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Запустить симуляцию", for: .normal)
        view.addTarget(self, action: #selector(startSimulation), for: .touchUpInside)
        view.backgroundColor = .red
        view.setTitleColor(.white, for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupSubviews()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    private func setupSubviews() {
        view.addSubview(groupSizeTextField)
        view.addSubview(infectionFactorTextField)
        view.addSubview(infectionFactorLabel)
        view.addSubview(infectionPeriodTextField)
        view.addSubview(infectionPeriodLabel)
        view.addSubview(startSimulationButton)
        view.addSubview(groupSizeLabel)
        
        groupSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        groupSizeTextField.translatesAutoresizingMaskIntoConstraints = false
        infectionFactorLabel.translatesAutoresizingMaskIntoConstraints = false
        infectionFactorTextField.translatesAutoresizingMaskIntoConstraints = false
        infectionPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        infectionPeriodTextField.translatesAutoresizingMaskIntoConstraints = false
        startSimulationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            groupSizeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupSizeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            groupSizeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            groupSizeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            groupSizeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 10),
            groupSizeTextField.widthAnchor.constraint(equalToConstant: 200),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            infectionFactorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 16),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infectionFactorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            infectionFactorTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 10),
            infectionFactorTextField.widthAnchor.constraint(equalToConstant: 200),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 44),

            infectionPeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infectionPeriodLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 16),
            infectionPeriodLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infectionPeriodLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            infectionPeriodTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infectionPeriodTextField.topAnchor.constraint(equalTo: infectionPeriodLabel.bottomAnchor, constant: 10),
            infectionPeriodTextField.widthAnchor.constraint(equalToConstant: 200),
            infectionPeriodTextField.heightAnchor.constraint(equalToConstant: 44),

            
            startSimulationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSimulationButton.topAnchor.constraint(equalTo: infectionPeriodTextField.bottomAnchor, constant: 24),
            startSimulationButton.heightAnchor.constraint(equalToConstant: 44),
            startSimulationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            startSimulationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            

        ])
    }
    
    
    @objc private func startSimulation() {
        guard let groupSizeText = groupSizeTextField.text,
              let groupSize = Int(groupSizeText),
              groupSize > 0, groupSize <= 1000
        else {
            let alertController = UIAlertController(title: "Ошибка", message: "Количество людей в моделируемой группе должно быть от 1 до 1000 человек", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let infectionFactorText = infectionFactorTextField.text,
              let infectionFactor = Int(infectionFactorText),
              infectionFactor > 0, infectionFactor <= 8
        else {
            let alertController = UIAlertController(title: "Ошибка", message: "Количество людей, которых может заразить одни человек, должно быть от 1 до 8 человек", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let infectionPeriodText = infectionPeriodTextField.text,
              let infectionPeriod = Int(infectionPeriodText),
              infectionPeriod > 0, infectionPeriod < 5
        else {
            let alertController = UIAlertController(title: "Ошибка", message: "Период заражения должен быть от 1 до 5 секунд", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        
        let simulationViewController = SimulationViewController()
        simulationViewController.groupSize = groupSize
        simulationViewController.infectionFactor = infectionFactor
        simulationViewController.infectionPeriod = infectionPeriod
        navigationController?.pushViewController(simulationViewController, animated: true)
    }

}



