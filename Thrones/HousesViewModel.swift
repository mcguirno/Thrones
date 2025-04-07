//
//  HousesViewModel.swift
//  Thrones
//
//  Created by Noah McGuire on 4/7/25.
//

import Foundation

@Observable
class HousesViewModel {
    var houses: [House] = []
    var urlString = "https://www.anapioficeandfire.com/api/houses?page=1&pageSize=50"
    var pageNumber = 1
    let pageSize = 50
    var isLoading = false
    func getData() async {
        guard pageNumber != 0 else {return}
        urlString = "https://www.anapioficeandfire.com/api/houses?page=\(pageNumber)&pageSize=\(pageSize)"
        print("We are accessing the url \(urlString)")
        isLoading = true
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create a url from \(urlString)")
            isLoading = false
            return
        }
        do {
            let configuration = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: configuration)
            let (data, _) = try await session.data(from: url)
            guard let houses = try? JSONDecoder().decode([House].self, from: data) else {
                print("ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            print("JSON returned: We have just returned another \(houses.count) houses")
            
            if houses.count < pageSize {
                pageNumber = 0
            } else {
                pageNumber += 1
            }
            
            Task { @MainActor in
                self.houses = self.houses + houses
                isLoading = false
            }
        } catch {
            print("ERROR: Could not get data from \(urlString) \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    func loadNextIfNeeded(house: House) async {
        guard let lastHouse = houses.last else {return}
        if house.id == lastHouse.id {
            Task {
                await getData()
            }
        }
    }
    
    func loadAll() async {
        guard pageNumber != 0 else {return}
        await getData()
        await loadAll()
    }
}

