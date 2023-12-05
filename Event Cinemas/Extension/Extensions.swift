//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    
    func displayPopover(with vc: UIViewController, contentSize: CGSize, permittedArrowDirections arrowDirections: UIPopoverArrowDirection, fromView: UIView) {
        vc.preferredContentSize = contentSize
        vc.modalPresentationStyle = .popover
        if let popoverPresentationController = vc.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = arrowDirections
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = fromView.convert(fromView.bounds, to: self.view)
        }
        present(vc, animated: true, completion: nil)
    }

    func hidePopover() {
        DispatchQueue.main.async {
            if self.presentedViewController != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
