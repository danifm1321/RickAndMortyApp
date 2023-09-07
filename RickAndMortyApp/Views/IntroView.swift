//
//  IntroView.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 7/9/23.
//

import SwiftUI

struct IntroView : View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Rick And Morty App")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .padding(.top, 50)
                
                Text("For this app, I wanted to propose 2 different approaches. The first one is a list with all the characters available. The second one, is a paginated list that only shows 20 characters per page.")
                    .padding()
                
                HStack(spacing: 30) {
                    NavigationLink(value: LIST_OPTIONS.SINGLE_LIST.rawValue) {
                        Text("Single List")
                            .foregroundColor(.primary)
                    }
                    .buttonStyle()
                    NavigationLink(value: LIST_OPTIONS.PAGINABLE_LIST.rawValue) {
                        Text("Paginable List")
                            .foregroundColor(.primary)
                    }
                    .buttonStyle()
                }
                .padding()


                Spacer()
            }
            .navigationDestination(for: Int.self) { listType in
                if listType == LIST_OPTIONS.SINGLE_LIST.rawValue {
                     CharactersList()
                } else if listType == LIST_OPTIONS.PAGINABLE_LIST.rawValue {
                    PaginableList()
                }
            }
            .navigationDestination(for: Character.self) { character in
                CharacterDetailView(character: character)
            }
        }

    }
}
