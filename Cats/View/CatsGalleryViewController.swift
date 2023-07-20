//
//  CatsGalleryViewController.swift
//  Cats
//
//  Created by admin on 20/07/23.
//

import UIKit

class CatsGalleryViewController: UIViewController {
    
    //CollectionView
    var collectionView: UICollectionView!
    //ViewModel
    var viewModel = CatsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        self.viewModel.delegate = self
        self.viewModel.getData()
    }
    
    //MARK: Setup View
    
    private func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CatsCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: UICollectionViewDataSource

extension CatsGalleryViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CatsCollectionViewCell
        DispatchQueue.global().async {
            let imageUrl = self.viewModel.imageModels[indexPath.item].imageUrl
            if let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                print("Image data loaded successfully.")
                print("Image size: \(image.size)")
                DispatchQueue.main.async {
                    cell.cellImageView.image = image
                }
            } else {
                print("Failed to load image data.")
            }
        }
        
        return cell
    }

}

//MARK: UICollectionViewDelegateFlowLayout

extension CatsGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 20) / 4
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

//MARK: CatsDelegate

extension CatsGalleryViewController: CatsDelegate {
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}



