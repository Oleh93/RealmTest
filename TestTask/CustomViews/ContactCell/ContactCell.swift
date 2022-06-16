//
//  ContactCell.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 16.06.2022.
//

import UIKit

final class ContactCell: UITableViewCell {
    // MARK: - Properties
    static var reuseIdentifier = "ContactCell"

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        label.textColor = .gray
        return label
    }()

    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }

    // MARK: - Public
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        numberLabel.text = contact.number
    }

    // MARK: - Private
    private func layout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(numberLabel)
    }
}
