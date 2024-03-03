//
//  DetailPresentationController.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

class DetailPresentationController: UIPresentationController {
    
    private let presentedYOffset: CGFloat = 100
    private let inset: CGFloat = 10

    private lazy var dimmingView: UIView! = {
        guard let container = containerView else {
            return nil
        }

        let view = UIView(frame: container.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.alpha = 0

        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else {
            return .zero
        }

        return CGRect(x: inset, y: self.presentedYOffset, width: container.bounds.width - inset * 2, height: container.bounds.height - self.presentedYOffset * 2)
    }

    override func presentationTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else {
            return
        }

        containerView?.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)

        coordinator.animate { [weak self] _ in
            self?.dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else {
            return
        }
        coordinator.animate { [weak self] _ in
            self?.dimmingView.alpha = 0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
