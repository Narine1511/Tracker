//
//  EmojiColorCell.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 18.07.2026.
//
import UIKit

final class EmojiColorViewCell: UICollectionViewCell {
    
    let emojiLabel = UILabel()
    let colorView = UIView()
    let selectionBorderView = UIView()
    let whiteBorderView = UIView()
        
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
        contentView.clipsToBounds = false
        
        // Добавляем colorView
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Добавляем эмодзи
        emojiLabel.font = .systemFont(ofSize: 24)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.backgroundColor = .ypWhite30
        emojiLabel.textAlignment = .center
        emojiLabel.clipsToBounds = true
        colorView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        
        // Добавляем белый бордюр для colorView
        contentView.addSubview(whiteBorderView)
        whiteBorderView.translatesAutoresizingMaskIntoConstraints = false
        whiteBorderView.layer.cornerRadius = 10
        whiteBorderView.layer.borderWidth = 3
        whiteBorderView.layer.borderColor = UIColor.ypLightGreen1.cgColor
        whiteBorderView.isHidden = true
        whiteBorderView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            whiteBorderView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            whiteBorderView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            whiteBorderView.widthAnchor.constraint(equalTo: colorView.widthAnchor, constant: 12),
            whiteBorderView.heightAnchor.constraint(equalTo: colorView.heightAnchor, constant: 12)
        ])

        // Добавляем бордюр для colorView
        contentView.addSubview(selectionBorderView)
        colorView.addSubview(selectionBorderView)
        selectionBorderView.translatesAutoresizingMaskIntoConstraints = false
        selectionBorderView.layer.cornerRadius = 12
        selectionBorderView.layer.borderWidth = 6
        selectionBorderView.layer.borderColor = UIColor.ypWhite.cgColor
        selectionBorderView.isHidden = true
        selectionBorderView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            selectionBorderView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            selectionBorderView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            selectionBorderView.widthAnchor.constraint(equalToConstant: 60),
            selectionBorderView.heightAnchor.constraint(equalToConstant: 60)
        ])
    
    }
    
    func configure(tracker: Tracker, isCompleted: Bool, count: Int) {
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emojiLabel.isHidden = true
        emojiLabel.text = nil
        colorView.isHidden = true
        colorView.backgroundColor = nil
        whiteBorderView.isHidden = true
        selectionBorderView.isHidden = true
        contentView.backgroundColor = .clear

    }
    func configureAsEmoji(_ emoji: String, isSelected: Bool) {
        emojiLabel.isHidden = false
        emojiLabel.text = emoji
        
        colorView.isHidden = true
        colorView.backgroundColor = nil
        
        colorView.isHidden = true
        
        if isSelected {
            contentView.backgroundColor = .ypLightGray
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    
    func configureAsColor(_ colorName: String, isSelected: Bool) {
        emojiLabel.isHidden = true
        colorView.isHidden = false
        
        colorView.backgroundColor = UIColor(named: colorName) ?? .ypSoftPink
        colorView.layer.cornerRadius = 8
        colorView.layer.borderWidth = 0
        
        if isSelected {
            contentView.backgroundColor = .clear
            
            whiteBorderView.isHidden = false
            selectionBorderView.isHidden = false
            
        } else {
            whiteBorderView.isHidden = true
            selectionBorderView.isHidden = true
        }
        /*contentView.layer.cornerRadius = 16*/
    }
}

final class SectionHeaderEmojiesAndColorsView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    private func setupUI() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    func configure(with title: String) {
        titleLabel.text = title
    }
}
