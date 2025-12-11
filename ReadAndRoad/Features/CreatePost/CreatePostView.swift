//
//  CreatePostView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/24/25.
//

import UIKit

class CreatePostView: UIView {
    
    // MARK: - UI elements
    
    var textViewContent: UITextView!
    
    var labelSpot: UILabel!
    var textFieldSpot: UITextField!
    var buttonAddSpot: UIButton!
    
    /// Autocomplete table for spot name suggestions.
    var tableViewAutocomplete: UITableView!
    
    /// List of spots with rating.
    var tableViewSpots: UITableView!
    
    var labelPhoto: UILabel!
    var buttonAddPhoto: UIButton!
    var collectionViewPhotos: UICollectionView!
    
    var buttonSubmit: UIButton!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupTextViewContent()
        setupSpotSection()
        setupSpotAutocompleteTable()
        setupSpotsTableView()
        setupPhotoSection()
        setupPhotosCollectionView()
        setupButtonSubmit()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupTextViewContent() {
        textViewContent = UITextView()
        textViewContent.font = .systemFont(ofSize: 16)
        textViewContent.layer.borderWidth = 1
        textViewContent.layer.borderColor = UIColor.systemGray4.cgColor
        textViewContent.layer.cornerRadius = 8
        textViewContent.text = ""
        textViewContent.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textViewContent)
    }
    
    private func setupSpotSection() {
        labelSpot = UILabel()
        labelSpot.text = "Related Spots"
        labelSpot.font = .systemFont(ofSize: 16, weight: .semibold)
        labelSpot.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelSpot)
        
        textFieldSpot = UITextField()
        textFieldSpot.placeholder = "Enter a spot name"
        textFieldSpot.borderStyle = .roundedRect
        textFieldSpot.autocorrectionType = .no
        textFieldSpot.autocapitalizationType = .none
        textFieldSpot.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldSpot)
        
        buttonAddSpot = UIButton(type: .system)
        buttonAddSpot.setTitle("Add", for: .normal)
        buttonAddSpot.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        buttonAddSpot.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonAddSpot)
    }
    
    /// Create table view for autocomplete suggestions.
    private func setupSpotAutocompleteTable() {
        tableViewAutocomplete = UITableView()
        tableViewAutocomplete.isHidden = true
        tableViewAutocomplete.layer.cornerRadius = 8
        tableViewAutocomplete.layer.borderWidth = 1
        tableViewAutocomplete.layer.borderColor = UIColor.systemGray4.cgColor
        tableViewAutocomplete.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableViewAutocomplete)
    }
    
    private func setupSpotsTableView() {
        tableViewSpots = UITableView()
        tableViewSpots.translatesAutoresizingMaskIntoConstraints = false
        tableViewSpots.tableFooterView = UIView()
        addSubview(tableViewSpots)
    }
    
    private func setupPhotoSection() {
        labelPhoto = UILabel()
        labelPhoto.text = "Photos"
        labelPhoto.font = .systemFont(ofSize: 16, weight: .semibold)
        labelPhoto.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelPhoto)
        
        buttonAddPhoto = UIButton(type: .system)
        buttonAddPhoto.setTitle("Add Photo", for: .normal)
        buttonAddPhoto.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        buttonAddPhoto.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonAddPhoto)
    }
    
    private func setupPhotosCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumLineSpacing = 8
        
        collectionViewPhotos = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewPhotos.backgroundColor = .clear
        collectionViewPhotos.showsHorizontalScrollIndicator = false
        collectionViewPhotos.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionViewPhotos)
    }
    
    private func setupButtonSubmit() {
        buttonSubmit = UIButton(type: .system)
        buttonSubmit.setTitle("Publish", for: .normal)
        buttonSubmit.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buttonSubmit.backgroundColor = .systemBlue
        buttonSubmit.tintColor = .white
        buttonSubmit.layer.cornerRadius = 10
        buttonSubmit.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonSubmit)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Content text view
            textViewContent.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            textViewContent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textViewContent.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textViewContent.heightAnchor.constraint(equalToConstant: 140),
            
            // Spot label
            labelSpot.topAnchor.constraint(equalTo: textViewContent.bottomAnchor, constant: 16),
            labelSpot.leadingAnchor.constraint(equalTo: textViewContent.leadingAnchor),
            
            // Spot text field + Add button
            textFieldSpot.topAnchor.constraint(equalTo: labelSpot.bottomAnchor, constant: 8),
            textFieldSpot.leadingAnchor.constraint(equalTo: textViewContent.leadingAnchor),
            
            buttonAddSpot.centerYAnchor.constraint(equalTo: textFieldSpot.centerYAnchor),
            buttonAddSpot.trailingAnchor.constraint(equalTo: textViewContent.trailingAnchor),
            buttonAddSpot.widthAnchor.constraint(equalToConstant: 70),
            
            textFieldSpot.trailingAnchor.constraint(equalTo: buttonAddSpot.leadingAnchor, constant: -8),
            textFieldSpot.heightAnchor.constraint(equalToConstant: 40),
            
            // Autocomplete table directly under spot text field
            tableViewAutocomplete.topAnchor.constraint(equalTo: textFieldSpot.bottomAnchor, constant: 4),
            tableViewAutocomplete.leadingAnchor.constraint(equalTo: textFieldSpot.leadingAnchor),
            tableViewAutocomplete.trailingAnchor.constraint(equalTo: textFieldSpot.trailingAnchor),
            tableViewAutocomplete.heightAnchor.constraint(equalToConstant: 150),
            
            // Spots table under autocomplete
            tableViewSpots.topAnchor.constraint(equalTo: tableViewAutocomplete.bottomAnchor, constant: 8),
            tableViewSpots.leadingAnchor.constraint(equalTo: textViewContent.leadingAnchor),
            tableViewSpots.trailingAnchor.constraint(equalTo: textViewContent.trailingAnchor),
            tableViewSpots.heightAnchor.constraint(equalToConstant: 150),
            
            // Photo section
            labelPhoto.topAnchor.constraint(equalTo: tableViewSpots.bottomAnchor, constant: 16),
            labelPhoto.leadingAnchor.constraint(equalTo: textViewContent.leadingAnchor),
            
            buttonAddPhoto.centerYAnchor.constraint(equalTo: labelPhoto.centerYAnchor),
            buttonAddPhoto.trailingAnchor.constraint(equalTo: textViewContent.trailingAnchor),
            
            collectionViewPhotos.topAnchor.constraint(equalTo: labelPhoto.bottomAnchor, constant: 8),
            collectionViewPhotos.leadingAnchor.constraint(equalTo: textViewContent.leadingAnchor),
            collectionViewPhotos.trailingAnchor.constraint(equalTo: textViewContent.trailingAnchor),
            collectionViewPhotos.heightAnchor.constraint(equalToConstant: 100),
            
            // Submit button
            buttonSubmit.topAnchor.constraint(equalTo: collectionViewPhotos.bottomAnchor, constant: 24),
            buttonSubmit.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonSubmit.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            buttonSubmit.heightAnchor.constraint(equalToConstant: 46),
            buttonSubmit.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
}
