//
//  DetailScreenTransitionDelegate.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 04.03.2024.
//

import UIKit

final class DetailScreenTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        DetailPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
