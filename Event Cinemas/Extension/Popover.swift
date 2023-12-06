//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol PopoverDelegate: AnyObject {
    func configurePopover(for navController: UINavigationController, sourceView: UIView, sourceRect: CGRect)
}

extension PopoverDelegate where Self: UIViewController & UIPopoverPresentationControllerDelegate {
    func configurePopover(for navController: UINavigationController, sourceView: UIView, sourceRect: CGRect) {
        navController.modalPresentationStyle = .popover
        navController.preferredContentSize = CGSize(width: view.bounds.width, height: 200)
        
        if let popoverController = navController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceRect
            popoverController.permittedArrowDirections = .up
            popoverController.delegate = self
            popoverController.backgroundColor = .white
            popoverController.passthroughViews = [sourceView]
        }
        
        present(navController, animated: true) {
            self.view.isUserInteractionEnabled = false
            sourceView.isUserInteractionEnabled = true
        }
    }
}
