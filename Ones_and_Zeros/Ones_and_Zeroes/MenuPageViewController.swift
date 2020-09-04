//
//  MenuPageViewController.swift
//  Ones_and_Zeroes
//
//  Created by Hannah Newby-Smith on 11/8/18.
//  Copyright © 2018 Jonah Pincetich. All rights reserved.
//

import UIKit

class MenuPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {


    // All the view controllers in the swipe home menu. Creates navigation for us.
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(ViewController: "sbPlay"), self.newViewController(ViewController: "sbDecks"), self.newViewController(ViewController: "sbSettings")]
    }()
   
    // page control dots on bottom of home menu for swiping
    var pageControl = UIPageControl()
    
    /**************************************************************************
     Function:       viewDidLoad
     
     Description:    Called when screen loads
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground() // makes it circuit background
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
        }

        self.delegate = self
        configurePageControl()
        // Do any additional setup after loading the view.
    }
    
    /**************************************************************************
     Function:       assignbackgound
     
     Description:    takes image and sets it as background for screen
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    func assignbackground(){
        let background = UIImage(named: "circut")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    /**************************************************************************
     Function:      configurePageControl
     
     Description:   Keeps track of home screens so app knows navigation,
                    also sets color og page control dots
     
     Parameters:     none
     
     Returned:       none
     *************************************************************************/
    func configurePageControl ()
    {
        pageControl = UIPageControl (frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    /**************************************************************************
     Function:       newViewController
     
     Description:    Creates a new view controller
     
     Parameters:     ViewController: String - name of ViewController
     
     Returned:       UIViewController
     *************************************************************************/
    func newViewController (ViewController: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewController)
    }
    
    /**************************************************************************
     Function:       pageViewController
     
     Description:    controls navigation of home menu
     
     Parameters:     _ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController
     
     Returned:       UIViewController
     *************************************************************************/
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else{
                return nil
    }
        
        let previousIndex = viewControllerIndex - 1
        
        // If on the first page and swipe right, dont go anywhere
        guard previousIndex >= 0 else{
               //return orderedViewControllers.last
            return nil
        }
        
        //If on last page and swipe left, dont go anywhere
        guard orderedViewControllers.count > previousIndex
            else{
                return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    /**************************************************************************
     Function:       pageViewController
     
     Description:    controls navigation of home menu
     
     Parameters:     _ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController
     
     Returned:       UIViewController
     *************************************************************************/
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else{
            //return orderedViewControllers.first
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex
            else{
                return nil
        }
        return orderedViewControllers[nextIndex]
    }
    /**************************************************************************
     Function:       pageViewController
     
     Description:    controls navigation of home menu
     
     Parameters:     _ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool
     
     Returned:       none
     *************************************************************************/
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }


}
