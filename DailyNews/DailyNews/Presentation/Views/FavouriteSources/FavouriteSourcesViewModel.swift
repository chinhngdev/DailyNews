//
//  FavouriteSourcesViewModel.swift
//  DailyNews
//
//  Created by Chinh on 8/21/25.
//

import Foundation

protocol FavouriteSourcesViewModelOutput {}

protocol FavouriteSourcesViewModelInput {
    func fetchSources()
}

typealias FavouriteSourcesViewModel = FavouriteSourcesViewModelInput & FavouriteSourcesViewModelOutput

final class DefaultFavouriteSourcesViewModel {
}

extension DefaultFavouriteSourcesViewModel: FavouriteSourcesViewModel {
    func fetchSources() {
    }
}
