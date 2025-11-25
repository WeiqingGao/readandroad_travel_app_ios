//
//  CreatePostView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/24/25.
//

import UIKit

class CreatePostView: UIView {

    // MARK: - UI

    // 输入帖子内容
    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // Spot 输入框
    let spotTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add a Spot"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // 添加 Spot 按钮
    let addSpotButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Spot", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // Spot+评分 列表
    let spotsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        return tv
    }()

    // 添加图片按钮
    let addPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Photo", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // 图片预览集合
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()

    // 发布按钮
    let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Publish", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        addSubview(contentTextView)
        addSubview(spotTextField)
        addSubview(addSpotButton)
        addSubview(spotsTableView)
        addSubview(addPhotoButton)
        addSubview(photosCollectionView)
        addSubview(submitButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentTextView.heightAnchor.constraint(equalToConstant: 150),

            spotTextField.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            spotTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            spotTextField.trailingAnchor.constraint(equalTo: addSpotButton.leadingAnchor, constant: -10),
            spotTextField.heightAnchor.constraint(equalToConstant: 44),

            addSpotButton.centerYAnchor.constraint(equalTo: spotTextField.centerYAnchor),
            addSpotButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addSpotButton.widthAnchor.constraint(equalToConstant: 90),

            spotsTableView.topAnchor.constraint(equalTo: spotTextField.bottomAnchor, constant: 10),
            spotsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            spotsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            spotsTableView.heightAnchor.constraint(equalToConstant: 200),

            addPhotoButton.topAnchor.constraint(equalTo: spotsTableView.bottomAnchor, constant: 20),
            addPhotoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            photosCollectionView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 10),
            photosCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photosCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 100),

            submitButton.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
