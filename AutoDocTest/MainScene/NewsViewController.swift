//
//  ViewController.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

class NewsViewController: UIViewController {

    private let viewModel: NewsViewModel
    
    init(vm: NewsViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }


}

