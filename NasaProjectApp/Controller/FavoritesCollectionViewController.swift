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
    
   // var photoCoreData: Photo!
    
   /*
    @IBAction func goBackToCalendar(_ sender: Any) {
        
        let controller: SettingsViewController
        controller = storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
        controller.dataController = dataController
        present(controller, animated: true, completion: nil)
    }
    */
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBAction func backToCalendar(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        self.loadView()
    }
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFetchedResultsController()
        self.loadView()
        print("View Did Appear")
    }
 */
    
    func setupFetchedResultsController() {
        print("111")
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        print("222")
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        print("333")
        fetchRequest.sortDescriptors = [sortDescriptor]
        print("444")
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        print("555")
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
            print("Number of Objects is:")
            print(fetchedResultsController?.sections?[0].numberOfObjects ?? 0)
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
        let photoCoreData = fetchedResultsController?.object(at: indexPath)
        let photoData = photoCoreData?.pic
        if let photoData = photoData {
        let thisImage = UIImage(data: photoData)
            cell.imageView.image = thisImage
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
        
    //    controller.photoCoreData = photoCoreData
     //   print(photoCoreData)
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


