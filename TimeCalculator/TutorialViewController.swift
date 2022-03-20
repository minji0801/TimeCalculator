//
//  TutorialViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2022/01/18.
//

import UIKit

final class TutorialViewController: UIViewController {
    private let images = ["page0", "page1", "page2", "page3"]
    private lazy var texts = [String]()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguage()

        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0

        imageView.image = UIImage(named: images[0])
        label.text = texts[0]

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
    }

    // close
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "showedTutorial")
        dismiss(animated: false)
    }

    // swipe
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if pageControl.currentPage != 5 {
                    pageControl.currentPage += 1
                }
                pageChange()
            case UISwipeGestureRecognizer.Direction.right :
                if pageControl.currentPage != 0 {
                    pageControl.currentPage -= 1
                }
                pageChange()
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
        let language = LanguageManaer.currentLanguage()
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
                    ?? Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)

        texts.append(bundle?.localizedString(forKey: "tutorial_page0", value: nil, table: nil) ?? "")
        texts.append(bundle?.localizedString(forKey: "tutorial_page1", value: nil, table: nil) ?? "")
        texts.append(bundle?.localizedString(forKey: "tutorial_page2", value: nil, table: nil) ?? "")
        texts.append(bundle?.localizedString(forKey: "tutorial_page3", value: nil, table: nil) ?? "")
    }
}
