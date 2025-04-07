//
//  ContentView.swift
//  Thrones
//
//  Created by Noah McGuire on 4/7/25.
//

import SwiftUI

struct ListView: View {
    @State private var housesVM = HousesViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                List(housesVM.houses) { house in
                    LazyVStack(alignment: .leading) {
                        Text(house.name)
                            .font(.title2)
                    }
                    .task {
                        await housesVM.loadNextIfNeeded(house: house)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Houses of Westeros:")
                
                if housesVM.isLoading {
                    ProgressView()
                        .scaleEffect(4)
                        .tint(.red)
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text("\(housesVM.houses.count) houses returned")
                }
            }
        }
        .task {
            await housesVM.getData()
        }
    }
}

#Preview {
    ListView()
}
