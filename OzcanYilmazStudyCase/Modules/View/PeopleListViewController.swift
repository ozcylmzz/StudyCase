//
//  PeopleListViewController.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import UIKit

class PeopleListViewController: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    var presenter: PeopleListPresenterProtocol?
    private var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        presenter = PeopleListPresenter(interactor: PeopleListInteractor(dataSource: DataSource()))
        presenter?.setView(self)
        presenter?.viewDidLoad()
    }
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        
        loadingIndicator.hidesWhenStopped = true
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func refreshList() {
        presenter?.refreshList()
    }
}

extension PeopleListViewController: PeopleListViewProtocol {
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func showPeople(_ people: [Person]) {
        DispatchQueue.main.async {
            self.people = people
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showEmptyListMessage() {
        let alertController = UIAlertController(title: "Empty List", message: "No people found.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension PeopleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.fullName + person.id.description
        return cell
    }
}

extension PeopleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == people.count - 1 {
            presenter?.loadNextPage()
        }
    }
}
