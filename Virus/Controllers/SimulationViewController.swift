//
//  SimulationViewController.swift
//  Virus
//
//  Created by Евгений Житников on 05.05.2023.
//

import UIKit

class SimulationViewController: UIViewController, UIGestureRecognizerDelegate {
    var cellsModel: CellsModel!
    var timer: Timer?
    var isTimerRunning = false
    var groupSize: Int?
    var infectionFactor: Int?
    var infectionPeriod: Int = 0
    private var selectedIndexPaths: Set<IndexPath> = []
    private let cellWidth = UIScreen.main.bounds.width / 20

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PersoneCell.self, forCellWithReuseIdentifier: "PersoneCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var personLabel:UILabel = {
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
        navigationItem.leftBarButtonItem = backButton
        
        if let navigationController = navigationController {
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.barTintColor = .black
            navigationController.navigationBar.tintColor = .white
        }
        
        setupConstraints()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.delegate = self
        collectionView.addGestureRecognizer(swipeGesture)
        
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
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func startTimer() {
        guard !isTimerRunning else {
            return
        }
        
        personLabel.textColor = .systemRed
        if !isTimerRunning {
            isTimerRunning = true
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(infectionPeriod), target: self, selector: #selector(updateCollectionView), userInfo: nil, repeats: true)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: collectionView)
            return abs(translation.x) > abs(translation.y)
        }
        return true
    }
    
    func finishSimulation() {
        stopTimer()
        let alert = UIAlertController(title: "Внимание!", message: "В популяции не осталось здоровых людей", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: { [weak self] _ in
            self?.stopTimer()
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func handleSelection(at indexPath: IndexPath) {
        selectedIndexPaths.insert(indexPath)
        cellsModel.cells[indexPath.item].isInfected = true
        collectionView.reloadItems(at: [indexPath])
        cellsModel.updateCellsModel(cellsModel)
        personLabel.textColor = .systemRed
        personLabel.text = "Заражено \(cellsModel.numberOfInfected) из \(cellsModel.groupSize)"
    }
    
    @objc private func goBack() {
        stopTimer()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateCollectionView() {
        cellsModel.infectTheNeighbors()
        collectionView.reloadData()
        personLabel.text = "Заражено \(cellsModel.numberOfInfected) из \(cellsModel.groupSize)"
    }
    
    @objc func handleSwipeGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
        case .began, .changed:
            if let indexPath = collectionView.indexPathForItem(at: location) {
                handleSelection(at: indexPath)
            }
            
        case .ended:
            if let indexPath = collectionView.indexPathForItem(at: location) {
                handleSelection(at: indexPath)
                startTimer()
            }
            
        default:
            break
        }
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
        
        personLabel.text = "Заражено \(cellsModel.numberOfInfected) из \(cellsModel.groupSize)"
        startTimer()
    }
}




