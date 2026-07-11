//
//  ViewController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 19.06.2026.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        let lable = UILabel()
        lable.text = "Трекеры"
        lable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lable)
        lable.tintColor = .ypBlack
        lable.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        lable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        
        lable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        lable.widthAnchor.constraint(equalToConstant: 254).isActive = true
        lable.heightAnchor.constraint(equalToConstant: 41).isActive = true
        
        let lableText = UILabel()
        lableText.text = "Что будем отслеживать?"
        lableText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lableText)
        lableText.tintColor = .ypBlack
        lableText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lableText.topAnchor.constraint(equalTo: view.topAnchor, constant: 490).isActive = true
        lableText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let image = UIImage(named: "star")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: lableText.topAnchor, constant: -8).isActive = true
        
        let textField = UITextField()
        textField.placeholder = " Поиск"
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 36),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: lable.bottomAnchor, constant: 7)
        ])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let searchImageView = UIImageView(image: searchIcon)
        searchImageView.tintColor = .gray
        searchImageView.contentMode = .scaleAspectFit
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        searchImageView.frame = CGRect(x: 12, y: 5, width: 20, height: 20)
        leftViewContainer.addSubview(searchImageView)

        textField.leftView = leftViewContainer
        textField.leftViewMode = .always

        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.calendar = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        view.addSubview(datePicker)
        
        
        let plusImage = UIImage(named: "plus")
        let button = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addTracker))
        button.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = button
    }
        
        @objc func datePickerValueChanged(_ sender: UIDatePicker) {
            let selectedDate = sender.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let formattedDate = dateFormatter.string(from: selectedDate)
            print("Выбранная дата: \(formattedDate)")
        }
    @objc func addTracker() {
        print("touch")
        let newTracker = NewTrackerController()
        present(newTracker, animated: true, completion: nil)
    }
    
    }

