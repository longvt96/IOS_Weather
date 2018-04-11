//
//  PageViewController.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/6/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    lazy var viewControllerList: [MainViewController] = {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
        if let tmpVc1 = vc1 as? MainViewController, let tmpVc2 = vc2 as? MainViewController {
            return [tmpVc1, tmpVc2]
        }
       return []
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
         self.dataSource = self
        if let first = viewControllerList.first {
            self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let tmpVc = (viewController as? MainViewController) {
            guard let vcIndex = viewControllerList.index(of: tmpVc ) else {
                return nil
            }
            let previousIndex = vcIndex - 1
            guard previousIndex >= 0  else {
                return nil
            }
            guard previousIndex < viewControllerList.count else {
                return nil
            }
            return viewControllerList[previousIndex]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let tmpVC = viewController as? MainViewController {
            guard let vcIndex = viewControllerList.index(of: tmpVC) else {
                return nil
            }
            let nextIndex = vcIndex + 1
            guard viewControllerList.count != nextIndex  else {
                return nil
            }
            guard viewControllerList.count > nextIndex else {
                return nil
            }
            return viewControllerList[nextIndex]
        }
        return nil
    }
}
