//
//  HalfModalViewController.swift
//  All Fit
//
//  Created by Lam Nguyen on 8/9/21.
//

import UIKit

class HalfPageModalViewController: UIViewController {

    // MARK: asset initialization
    public lazy var containerView: UIView = {                                              //Container view to store assets
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimAlpha: CGFloat = 0.6                                                  //Maximum alpha value for the dimmed view
    private lazy var dimmedView: UIView = {                                                 //Dimmed view
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimAlpha
        
        return view
    }()
    
    
    var defaultHeight: CGFloat = 350                                                //Default height of the container
    var dismissibleHeight: CGFloat = 200                                            //Height at which the container and view can be dismissed
    let maxmimumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64         //Maximum container height to show modally
    var currentContainerHeight: CGFloat = 350                                       //Current container height depending on gesture
    var containerViewBottomConstraint: NSLayoutConstraint?                          //Bottom constraint for container
    var containerViewHeightConstraint: NSLayoutConstraint?                          //Height constraint for the container
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Set up the views */
        addViewConstraints()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateDimmedView()
        animatePresentContainer()
    }
    
    // MARK: asset constraints
    
    /*
        @addViewConstraints
        Adds constraints to the container and dimmed view
     
     */
    private func addViewConstraints(){
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        //Add constraints to the dim and container view
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //dimmedView constraints
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //container constraints
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        containerViewBottomConstraint           = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint           = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint?.isActive = true
        containerViewHeightConstraint?.isActive = true
    }
    
    // MARK: animations
    /*
        @animatePresentContainer
        Animates the container when it first appears
     */
    private func animatePresentContainer(){
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    /*
        @animateDimmedView
        Animates the dimmed view when it first appears
     */
    private func animateDimmedView(){
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimAlpha
        }
    }
    
    /*
        @animateDismissView
        Animates the hiding of the container and dimmed view
     */
     func animateDismissView(){
        
        //Hide container view
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
        
        //Hide dim view
        dimmedView.alpha = maxDimAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    /*
        @animateContainerHeight
        Animates the container to a certain height
        -- height: height to animate to
     */
    func animateContainerHeight(_ height: CGFloat){
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        
        currentContainerHeight = height
    }
    
    // MARK: gestures functions
    
    /*
        @setupPanGesture
        Creates a gesture to detect dragging and size the view accordingly
     */
    func setupPanGesture(){
        // Build a gesture and add it to the view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        
        // Remove any delays to immediately listen to gesture movements
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
        
        //Add a gesture to the dimmed view so when clicked, the view controller is dismissed
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(gesture:)))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: objc functions
    
    /*
        @handlePanGesture
        Provide the right animations depending on the users drag gesture
     */
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // drag to top will be minus value and vice versa

        // get drag direction
        let isDraggingDown = translation.y > 0
        
        //Update the height based on value of dragging
        let newHeight = currentContainerHeight - translation.y
        
        //Perform animations depending on the state of the gesture and the height of the container
        switch gesture.state {
            case .changed:
                /* User is dragging*/
                
                if newHeight < maxmimumContainerHeight{
                    containerViewHeightConstraint?.constant = newHeight
                    view.layoutIfNeeded()
                }
            case .ended:
                /* User stop dragging*/
                
                if newHeight < dismissibleHeight{                                   //C1: New height is below the minimum, dismiss the view
                    self.animateDismissView()
                }
                else if newHeight < defaultHeight{                                  //C2: New height is below default, then animate back to default
                    animateContainerHeight(defaultHeight)
                }
                else if newHeight < maxmimumContainerHeight && isDraggingDown{      //C3: New height is below max and going down, then animate back to default
                    animateContainerHeight(defaultHeight)
                }
                else if newHeight > defaultHeight && !isDraggingDown {              //C4: New height is below max and going up, set to max height
                    animateContainerHeight(maxmimumContainerHeight)
                }
            default:
                break
            }
    }
    
    /*
        @dimmedViewTapped
        Dismiss the view when the dimmed view is tapped
     */
    @objc func dimmedViewTapped(gesture: UIPanGestureRecognizer){
        self.animateDismissView()
    }
    
    

}

