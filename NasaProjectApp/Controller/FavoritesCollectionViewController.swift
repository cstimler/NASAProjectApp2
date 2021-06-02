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
    
    var selectedDateLabel: String?
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBAction func backToCalendar(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupFetchedResultsController()
        mathForCalculatingCollectionViewCell()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        self.loadView()

    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "fix")
        
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
            print("Number of Objects is:")
            print(fetchedResultsController?.sections?[0].numberOfObjects ?? 0)
        } catch {
            fatalError("Unable to fetch: \(error.localizedDescription)")
    }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicCollectionViewCell
        // The following "if" seems to patch up a bug in the iOS operating system which was causing occasional crashes upon rotation, see:
        // https://stackoverflow.com/questions/25049923/terminating-app-due-to-uncaught-exception-nsinternalinconsistencyexception-re
        if fetchedResultsController?.sections?[0].numberOfObjects ?? 0 > indexPath.item {
        // Configure the cell
        let photoCoreData = fetchedResultsController?.object(at: indexPath)
        let photoData = photoCoreData?.pic
        if let photoData = photoData {
        let thisImage = UIImage(data: photoData)
            cell.imageView.image = thisImage
        }
       
    }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // store the unique identifier of the photo - the dateLabel - in a global variable to be passed in segue
        selectedDateLabel = fetchedResultsController?.object(at: indexPath).dateLabel
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
        
        if segue.identifier == "fromFavoriteToFavorite"
        {
        let controller = segue.destination as! FavoritePhotosViewController
        controller.dataController = dataController
            controller.selectedDateLabel = selectedDateLabel
        
        }
        
        if segue.identifier == "unwindSegue"
        {
            let controller = segue.destination as! SettingsViewController
            controller.dataController = dataController
        }
        
    }

    // MARK: UICollectionViewDelegate

}

// adapted from: https://stackoverflow.com/questions/38028013/how-to-set-uicollectionviewcell-width-and-height-programmatically
    extension FavoritesCollectionViewController: UICollectionViewDelegateFlowLayout{
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
      {
                let dimension = mathForCalculatingCollectionViewCell()
                return CGSize(width: dimension, height: dimension)
        }

    
    }


