//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 14.08.2026.
//
import UIKit

final class StatisticsViewCell: UICollectionViewCell {
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.blueLinearGradient.cgColor,
            UIColor.greenLinearGradient.cgColor,
            UIColor.redLinearGradient.cgColor
        ]
        layer.locations = [0.0, 0.5, 1.0]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = 16
     
        return layer
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let whiteBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 14
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        /* view.layer.borderWidth = 1*/
        /*view.layer.borderColor = UIColor.ypGray.cgColor*/
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // Принудительно обновляем градиент
        DispatchQueue.main.async {
            self.gradientLayer.frame = self.containerView.bounds
        }
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        containerView.layer.masksToBounds = true
        
        containerView.addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubview(countLabel)
        whiteBackgroundView.addSubview(titleLabel)
        
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            whiteBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1),
            whiteBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 1),
            whiteBackgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -1),
            whiteBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1),
            
            countLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(count: Int, title: String) {
        countLabel.text = "\(count)"
        titleLabel.text = title
        
    }
}

