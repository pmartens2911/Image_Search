//
//  PhotoDetailsViewController.swift
//  Image Search
//
//  Created by Paul Martens on 4/2/20.
//  Copyright © 2020 PM. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    var photoDetails: PhotoDetails?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var otherDetailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let photo = photoDetails else {
            return
        }
        imageView.loadImage(urlString: photo.urls.regular)
        descriptionLabel.text = photo.description
        if let author = photo.user.username {
            otherDetailsLabel.text = "Photo By: " + author
        } else {
            otherDetailsLabel.text = ""
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
