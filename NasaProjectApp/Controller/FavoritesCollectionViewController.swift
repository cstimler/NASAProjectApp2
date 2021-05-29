//
//  FavoritesCollectionViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/28/21.
//

import UIKit
import CoreData

private let reuseIdentifier = "FavoritesPhotoCell"

class FavoritesCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var dataController: DataController!
    
    var fetchedResultsController:NSFetchedResultsController<Photo>?
    
    var photoCoreData: Photo!
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        mathForCalculatingCollectionViewCell()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

        // Do any additional setup after loading the view.
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error.localizedDescription)")
    }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicCollectionViewCell
    
        // Configure the cell
        photoCoreData = fetchedResultsController?.object(at: indexPath)
        let photoData = photoCoreData?.pic
        if let photoData = photoData {
        let thisImage = UIImage(data: photoData)
            cell.imageView.image = thisImage
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "fromFavoriteToFavorite", sender: self)
    }
    
    func mathForCalculatingCollectionViewCell() -> CGFloat {
        var dimension: CGFloat
        
        if UIDevice.current.orientation.isLandscape {
                let space:CGFloat = 3.0
         dimension = (view.frame.size.width - (5*space))/6.0
                flowLayout.minimumInteritemSpacing = space
                flowLayout.minimumLineSpacing = space
                    flowLayout.itemSize = CGSize(width:dimension, height:dimension)
            
        } else {
             
                
                let space:CGFloat = 3.0
         dimension = (view.frame.size.width - (2*space))/3.0
                flowLayout.minimumInteritemSpacing = space
                flowLayout.minimumLineSpacing = space
                    flowLayout.itemSize = CGSize(width:dimension, height:dimension)
            
            
        }
        return dimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! FavoritePhotosViewController
        
        controller.photoCoreData = photoCoreData
    }

    // MARK: UICollectionViewDelegate

}

// adapted from: https://stackoverflow.com/questions/38028013/how-to-set-uicollectionviewcell-width-and-height-programmatically
    extension FavoritesCollectionViewController: UICollectionViewDelegateFlowLayout{
      optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
      {
                let dimension = mathForCalculatingCollectionViewCell()
                return CGSize(width: dimension, height: dimension)
        }

    
    }


