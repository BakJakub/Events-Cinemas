//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func pushMovieDetail(data: MovieDetailResultModel) {
        let movieDetailViewController = MovieDetailViewController(data: data)
        navigationController.pushViewController(movieDetailViewController, animated: true)
    }
}
