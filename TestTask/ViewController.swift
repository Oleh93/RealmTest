//
//  ViewController.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 16.06.2022.
//

import UIKit
import RealmSwift

struct ContactSection {
    let firstLetter: String
    let contacts: [Contact]
}

final class ViewController: UIViewController {
    // MARK: - Properties
    private var realm: Realm = {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        return realm
    }()

    private var sections: [ContactSection] = []

    private let tableView = UITableView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        layout()
        setupTableView()
        loadContacts()
    }
}

// MARK: - Private
private extension ViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func loadContacts() {
        var contacts = getContactsFromRealm()

        // check if Realm contains contacts
        if contacts.isEmpty {
            // load contacts from json
            contacts = getContactsFromJson()

            try? realm.write({
                realm.add(contacts.map { $0.realmEntity })
            })
        }

        let groupedDictionary = Dictionary(grouping: contacts, by: { $0.firstNameLetter ?? "" })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map {
            ContactSection(
                firstLetter: $0,
                contacts: groupedDictionary[$0]?.sorted(by: { $0.name < $1.name }) ?? []
            )
        }

        tableView.reloadData()
    }

    func getContactsFromRealm() -> [Contact] {
        let contactsRealm = realm.objects(ContactRealm.self)
        let contacts = Array(contactsRealm).map { $0.entity }
        return contacts
    }

    func getContactsFromJson() -> [Contact] {
        guard let path = Bundle.main.path(forResource: "contacts", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let decoded = try? JSONDecoder().decode([Contact].self, from: data)
        else {
            fatalError("failed to find or decode contacts from json file")
        }
        return decoded
    }

    func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseIdentifier, for: indexPath) as? ContactCell
        else {
            fatalError("failed to dequeue ContactCell")
        }
        let contact = sections[indexPath.section].contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].contacts.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map { $0.firstLetter }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].firstLetter
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
