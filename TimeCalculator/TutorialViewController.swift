//
//  TutorialViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2022/01/18.
//

import UIKit

class TutorialViewController: UIViewController {
    let images = ["page0", "page1", "page2", "page3"]
    var texts = [String]()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguage()

        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        imageView.image = UIImage(named: images[0])
        label.text = texts[0]
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // skip
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "showedTutorial")
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if pageControl.currentPage != 5 {
                    pageControl.currentPage += 1
                }
                self.pageChange()
            case UISwipeGestureRecognizer.Direction.right :
                if pageControl.currentPage != 0 {
                    pageControl.currentPage -= 1
                }
                self.pageChange()
            default:
                break
            }
        }
    }
    
    func pageChange() {
        imageView.image = UIImage(named: images[pageControl.currentPage])
        label.text = texts[pageControl.currentPage]
    }
    
    // 언어 설정
    func setLanguage() {
        var language = UserDefaults.standard.array(forKey: "Language")?.first as? String
        if language == nil {
            let str = String(NSLocale.preferredLanguages[0])
            language = String(str.dropLast(3))
        }
        let path = Bundle.main.path(forResource: language, ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        self.texts.append(bundle?.localizedString(forKey: "tutorial_page0", value: nil, table: nil) ?? "")
        self.texts.append(bundle?.localizedString(forKey: "tutorial_page1", value: nil, table: nil) ?? "")
        self.texts.append(bundle?.localizedString(forKey: "tutorial_page2", value: nil, table: nil) ?? "")
        self.texts.append(bundle?.localizedString(forKey: "tutorial_page3", value: nil, table: nil) ?? "")
    }
}
