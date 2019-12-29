//
//  ViewController.swift
//  swifty-collection-view-example
//
//  Created by Nadia Barbosa on 12/28/19.
//  Copyright © 2019 nbsa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let values = (1...30).map { $0 }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        // Register the custom cell class to use
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "reusableCell")
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        /**
         We want to use our custom cell class here, so cast it as our custom type
         when we retrieve it from the reuse queue or when we create a new one.
         */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! CustomCollectionViewCell
        cell.numberValue = values[indexPath.row]

        return cell
    }
}

class CustomCollectionViewCell: UICollectionViewCell {

    var numberView: UILabel!

    var numberValue: Int? {
        didSet {
            updateSubviews()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateSubviews() {

        /**
         Prevent overlapping subviews by erasing previous ones if they exist.

         If you were to comment this if statement out, subviews and constraints
         would continue to compound on each other when scrolling.
         To avoid this, the cell's subviews need to be reset when the cell
         is coming off of the reuse queue.
         */
        if numberView != nil {
            self.numberView.removeFromSuperview()
        }

        configureLabel()
    }

    private func configureLabel() {
        // Skip everything below if self.numberValue is nil
        guard let numberValue = self.numberValue else { return }

        // Setup label & constraints
        numberView = UILabel(frame: CGRect.zero)
        numberView.translatesAutoresizingMaskIntoConstraints = false
        numberView.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        numberView.text = "\(numberValue)"

        /**
         Always add custom content to a `UICollectionViewCell`'s `contentView`,
         not the actual `UICollectionViewCell` itself.
         */
        self.contentView.addSubview(numberView)

        NSLayoutConstraint.activate([
            numberView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
