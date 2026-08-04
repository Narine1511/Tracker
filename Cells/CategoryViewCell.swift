//
//  CategoryViewCell.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 03.08.2026.
//

import UIKit

final class CategoryViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        backgroundColor = .ypLightGray
        selectionStyle = .default
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
        layer.cornerRadius = 0
        layer.masksToBounds = false
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func configure(with title: String, isSelected: Bool, isLastRow:Bool) {
        titleLabel.text = title
        
        accessoryType = isSelected ? .checkmark : .none
        tintColor = .ypBlue
        print("🔍 Ячейка: \(title), isLastRow: \(isLastRow)")
        if isLastRow {
            layer.cornerRadius = 12
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            layer.masksToBounds = true
            separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: .greatestFiniteMagnitude)
            
        } else {
            layer.cornerRadius = 0
            layer.masksToBounds = false
            separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
    }
}
