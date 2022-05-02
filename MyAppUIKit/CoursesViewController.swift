//
//  CoursesViewController.swift
//  MyAppUIKit
//
//  Created by Luccas Santana Marinho on 02/05/22.
//

import UIKit

public protocol DataFetchable {
    func fetchCourseNames(completion: @escaping ([String]) -> Void)
}

struct Course {
    let name: String
}

public class CoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataFetchable: DataFetchable
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    public init(dataFetchable: DataFetchable) {
        self.dataFetchable = dataFetchable
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    var course: [Course] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        dataFetchable.fetchCourseNames { [weak self] names in
            self?.course = names.map { Course(name: $0) }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = course[indexPath.row].name
        return cell
    }
}
