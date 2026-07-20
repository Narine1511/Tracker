//
//  TrackersCollectionCellView.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 08.07.2026.
//

import UIKit
protocol TrackersCollectionViewCellDelegate: AnyObject {
    func didTapCompleteButton(for trackerId: UUID, isCompleted: Bool) -> Bool
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    /*  let titleLable = UILabel()*/
    let textLabel = UILabel()
    let emoji = UILabel()
    let complitebButton = UIButton()
    let countLabel = UILabel()
    let colorView = UIView()
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    private var trackerId: UUID?
    private var isCompleted: Bool = false
    private var completionCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        
        // Добавляем colorView
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 16
        colorView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        // Настройка заголовка
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = .ypWhite
        colorView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 12),
            textLabel.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)])
        
        // Настройка эмодзи
        emoji.font = .systemFont(ofSize: 21)
        emoji.textAlignment = .center
        emoji.baselineAdjustment = .alignCenters
        emoji.contentMode = .center
        
        emoji.backgroundColor = .ypWhite30
        emoji.layer.cornerRadius = 12
        
        emoji.clipsToBounds = true
        colorView.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          
           emoji.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 12),
            emoji.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            emoji.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        // Настройка кнопки
        complitebButton.setImage(UIImage(named: "buttonCompleted"), for: .normal)
        /*complitebButton.setImage(buttonImage, for: .normal)*/
        complitebButton.translatesAutoresizingMaskIntoConstraints = false
        complitebButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        contentView.addSubview(complitebButton)
        
        NSLayoutConstraint.activate([
            complitebButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            complitebButton.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -12),
            complitebButton.heightAnchor.constraint(equalToConstant: 34),
            complitebButton.widthAnchor.constraint(equalToConstant: 34)
            
        ])
        
        // Настройка счётчика
        countLabel.font = .systemFont(ofSize: 12, weight: .medium)
        countLabel.textColor = .ypBlack
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            countLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12)
        ])
    }
    
    func configure(tracker: Tracker, isCompleted: Bool, count: Int) {
        
        self.trackerId = tracker.id
        self.isCompleted = isCompleted
        self.completionCount = count
        
        contentView.backgroundColor = .ypWhite
        colorView.backgroundColor = UIColor(named: tracker.color) ?? .ypGreen
        emoji.text = tracker.emoji
        textLabel.text = tracker.label
        textLabel.textColor = .ypWhite
        countLabel.text = "\(count) дней"
        updateButton()
        
    }
    private func updateButton() {
     if isCompleted {
     let image = UIImage(named: "button_ checkmark")
         complitebButton.setImage(image, for: .normal)
     } else {
     let image = UIImage(named: "buttonCompleted")
         complitebButton.setImage(image, for: .normal)
     }
    }
    
    @objc private func buttonTapped() {
        guard let trackerId = trackerId else { return }
        print("КНОПКА НАЖАТА!")
        
        let newState = !isCompleted
        let canChange = delegate?.didTapCompleteButton(for: trackerId, isCompleted: newState) ?? false
        if !canChange {return}
        
        
        isCompleted = newState
        if isCompleted {
            completionCount += 1
        } else {
            completionCount -= 1
        }
        countLabel.text = "\(completionCount) дней"
       updateButton()
        /*delegate?.didTapCompleteButton(for: trackerId, isCompleted: isCompleted)*/
    }

}
