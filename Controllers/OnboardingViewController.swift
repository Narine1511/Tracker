//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 26.07.2026.
//
import UIKit

class OnboardingPageViewController: UIViewController {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let actionButton = UIButton()
   
    init(imageName: String, title: String, buttonTitle: String = "Вот это технологии!") {
        super.init(nibName: nil, bundle: nil)
        setupUI(imageName: imageName, title: title, buttonTitle: buttonTitle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(imageName: String, title: String, buttonTitle: String) {
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .ypBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        actionButton.backgroundColor = .ypBlack
        actionButton.tintColor = .ypWhite
        actionButton.layer.cornerRadius = 16
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -160),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -84),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc private func buttonTapped() {
        // Отправляем уведомление о нажатии кнопки

        NotificationCenter.default.post(name: NSNotification.Name("navigateToMainScreen"), object: nil)
    }
    
}

class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    weak var sceneDelegate: SceneDelegate?
    
    lazy var pages: [UIViewController] = {
        
        let pageData: [(image: String, title: String, button: String)] = [
            ("onboardingBlueScreen", "Отслеживайте только то, что хотите", "Вот это технологии!" ),
            ("onboardingPinkScreen", "Даже если это не литры воды и йога", "Вот это технологии!")
        ]
        
        return pageData.map { data in
            OnboardingPageViewController(
                imageName: data.image,
                title: data.title,
                buttonTitle: data.button
            )
        }
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setupUI()
        
     /*   NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNextButton),
            name: NSNotification.Name("NextButtonTapped"),
            object: nil
        )*/
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(navigateToMainScreen),
               name: NSNotification.Name("navigateToMainScreen"),
               object: nil
               )
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -72),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
    }
    
    
    @objc private func skipTapped() {
        navigateToMainScreen()
    }
    
    @objc private func handleNextButton() {
        guard let currentVC = viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentVC) else {
            return
        }
        let nextIndex = currentIndex + 1
        
        if nextIndex < pages.count {
            setViewControllers([pages[nextIndex]], direction: .forward, animated: true)
            pageControl.currentPage = nextIndex
        } else {
            /*pageControl.currentPage = nextIndex*/
            navigateToMainScreen()
        }
    }
    
   /* @objc  private func navigateToMainScreen() {
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")
        UserDefaults.standard.synchronize()
        
        let mainVC = ViewController()
        
        guard let window = UIApplication.shared.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = mainVC
        }, completion: nil)
        
    }*/
    
    @objc private func navigateToMainScreen() {
        print("🟢 goToMainScreen() ВЫЗВАН")
        print("🔵 sceneDelegate: \(sceneDelegate != nil ? "ЕСТЬ ✅" : "НЕТ ❌")")
        
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")
        sceneDelegate?.showMainApp()
    }
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
            
            if currentIndex == pages.lastIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
                
                    /*navigateToMainScreen()*/
                }
            }
        }
    }
