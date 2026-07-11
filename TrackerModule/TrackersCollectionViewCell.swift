//
//  TrackersCollectionCellView.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 08.07.2026.
//

import UIKit
import Foundation

final class TrackersCollectionViewCell: UICollectionViewCell {
  /*  let titleLable = UILabel()*/
    let textLable = UILabel()
    let emoji = UILabel()
    let complitebButton = UIButton()
    let countLable = UILabel()
    let colorView = UIView()
    
    
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
        
        // Настройка заголовка
        textLable.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLable.textColor = .ypWhite
        contentView.addSubview(textLable)
        textLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            textLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 12)])
        
        // Настройка эмодзи
        emoji.font = .systemFont(ofSize: 24)
        emoji.layer.cornerRadius = 12
        contentView.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            emoji.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            emoji.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        // Настройка кнопки
        let buttonImage = UIImage(named: "buttonCompleted")
        let button = UIButton(type: .custom)
        button.setImage(buttonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 12),
            button.heightAnchor.constraint(equalToConstant: 34),
            button.widthAnchor.constraint(equalToConstant: 34)
            
        ])
        
        // Настройка счётчика
        countLable.font = .systemFont(ofSize: 12, weight: .medium)
        countLable.textColor = .ypBlack
        countLable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countLable)
        
        NSLayoutConstraint.activate([
            countLable.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            countLable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12)
        ])
    }
    
    func configure(tracker: Tracker, isCompleted: Bool, count: Int) {
        colorView.backgroundColor = .green
        emoji.text = tracker.emoji
        textLable.text = tracker.label
        countLable.text = "\(count) дней"
        
    }
    
}
