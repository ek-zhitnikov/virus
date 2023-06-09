//
//  Model.swift
//  Virus
//
//  Created by Евгений Житников on 08.05.2023.
//

import Foundation

struct PersoneCellModel {
    var isInfected: Bool = false
}



class CellsModel {
    var groupSize: Int = 0
    var infectionFactor: Int = 0
    var cells: [PersoneCellModel] = []
    var infectedIndexes = Set<Int>()
    var numberOfInfected: Int = 0
    weak var simulationViewController: SimulationViewController?

    init(simulationViewController: SimulationViewController) {
        self.simulationViewController = simulationViewController
        self.groupSize = simulationViewController.groupSize ?? 0
        self.infectionFactor = simulationViewController.infectionFactor ?? 0

        for _ in 0..<groupSize {
            cells.append(PersoneCellModel())
        }
    }
    
    func updateCellsModel(_ cellsModel: CellsModel) {
        
        for (index, cellModel) in cellsModel.cells.enumerated() {
            if cellModel.isInfected {
                cellsModel.infectedIndexes.insert(index)
            }
        }
        numberOfInfected = infectedIndexes.count        
    }
    
    func infectTheNeighbors() {
        if numberOfInfected < groupSize {
            for index in infectedIndexes {
                let index1 = index % 20
                let index2 = (index + 1) % 20
                let index3 = groupSize - 21
                var listOfNeighbors = [Int]()
                
                if (index > 0) && (index1 != 0){
                    let leftIndex = index - 1
                    listOfNeighbors.append(leftIndex)
                }
                if index < index3 + 20 && index2 != 0 {
                    let rightIndex = index + 1
                    listOfNeighbors.append(rightIndex)
                }
                if index > 20  {
                    let upIndex = index - 20
                    listOfNeighbors.append(upIndex)
                }
                if index > 20 && (index1 != 0) {
                    let upLeftIndex = index - 21
                    listOfNeighbors.append(upLeftIndex)
                }
                if index > 20 && index2 != 0 {
                    let upRightIndex = index - 19
                    listOfNeighbors.append(upRightIndex)
                }
                if index < index3 && index2 != 0 {
                    let downIndex = index + 20
                    listOfNeighbors.append(downIndex)
                    
                }
                if index < index3 && (index1 != 0) {
                    let downLeftIndex = index + 19
                    listOfNeighbors.append(downLeftIndex)
                    
                }
                if index < index3 && index2 != 0 {
                    let downRightIndex = index + 21
                    listOfNeighbors.append(downRightIndex)
                    
                }
                
                let shuffledNeighbors = listOfNeighbors.shuffled()
                let randomNeighbors = Array(shuffledNeighbors.prefix(infectionFactor))
                for index in randomNeighbors {
                    let i = Int.random(in: 0...1)
                    if i == 1 {
                        cells[index].isInfected = true
                    }
                }
            }
            updateCellsModel(self)
        } else {
            simulationViewController?.finishSimulation()
        }
    }
}


