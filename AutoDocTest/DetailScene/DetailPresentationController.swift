//
//  DetailPresentationController.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

final class DetailPresentationController: UIPresentationController {
    
    private let presentedYOffset: CGFloat = 100
    private let inset: CGFloat = 10
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return tapGesture
    }()
    
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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let size: CGSize = CGSize(width: 400, height: 600)
            let origin: CGPoint = CGPoint(x: container.center.x - size.width / 2, y: container.center.y - size.height / 2)
            return CGRect(origin: origin, size: size)
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
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
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
            dimmingView.removeGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
}
