//
//  SimulationViewController.swift
//  Virus
//
//  Created by Евгений Житников on 05.05.2023.
//

import UIKit

class SimulationViewController: UIViewController {
    var cellsModel: CellsModel!
    var timer: Timer?
    var isTimerRunning = false
    var groupSize: Int?
    var infectionFactor: Int?
    var infectionPeriod: Int = 0
    

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var personLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Выберите человека, которого вирус поразит первым"
        view.lineBreakMode = .byWordWrapping
        view.textColor = .systemGreen
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        cellsModel = CellsModel(simulationViewController: self)

        let backButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(goBack))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        setupCollectionView()
        setupConstraints()
    }
    

    
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.register(PersoneCell.self, forCellWithReuseIdentifier: "PersoneCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 20
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        bottomView.addSubview(personLabel)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        personLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 60),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            personLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            personLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            personLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            personLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16)

        ])
    }
    
    func stopTimer() {
        timer?.invalidate()
        let alert = UIAlertController(title: "Внимание!", message: "В популяции не осталось здоровых людей", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: { [weak self] _ in
            self?.timer?.invalidate()
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Вы действительно хотите закончить симуляцию?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            self?.timer?.invalidate()
            self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func goBack() {
        showAlert()
    }
    
    @objc func updateCollectionView() {
        cellsModel.infectTheNeighbors()
        collectionView.reloadData()
        personLabel.text = "Заражено \(cellsModel.numberOfInfected) из \(cellsModel.groupSize)"
    }
}

extension SimulationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsModel.groupSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersoneCell", for: indexPath) as! PersoneCell
        cell.model = cellsModel.cells[indexPath.item]
        return cell
    }
}

extension SimulationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellsModel.cells[indexPath.item].isInfected = true
        collectionView.reloadData()
        cellsModel.updateCellsModel(cellsModel)
        personLabel.textColor = .systemRed
        personLabel.text = "Заражено \(cellsModel.numberOfInfected) из \(cellsModel.groupSize)"
        
        if !isTimerRunning {
            isTimerRunning = true
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(infectionPeriod), target: self, selector: #selector(updateCollectionView), userInfo: nil, repeats: true)
        }

    }
}



