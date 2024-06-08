//
//  DetailController.swift
//  Duksung
//
//  Created by mac10 on 6/9/24.
//

import UIKit
import WebKit

class DetailController: UIViewController {
    @IBOutlet var webView: WKWebView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlString!)
        let req = URLRequest(url: url!)
        webView.load(req)

        // Do any additional setup after loading the view.
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
