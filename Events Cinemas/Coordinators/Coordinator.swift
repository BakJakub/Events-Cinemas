//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func pushMovieDetail(data: MovieDetailResultModel) {
        let movieDetailViewController = MovieDetailViewController(data: data, coordinator: self)
        navigationController.pushViewController(movieDetailViewController, animated: true)
    }
    
    func popToPreviousViewController() {
        navigationController.popViewController(animated: true)
    }
}
