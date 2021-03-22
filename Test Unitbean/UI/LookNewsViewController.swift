//
//  LookNewsViewController.swift
//  Test Unitbean
//
//  Created by Александр Рублев on 18.03.2021.
//

import UIKit

class LookNewsViewController: UITableViewController {
    
    private var dataFetcher: NetworkDataFetcher!
    private var news: [NewsModel] = []
    private var selectedNews: NewsModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataFetcher = NetworkDataFetcher(networkService: NetworkService())
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        setupTableView()
        setupTitleView()
    }
    
    private func setupBindings() {
        dataFetcher.getNews { [weak self] news, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let news = news {
                self?.news = news
            }
            self?.tableView.reloadData()
        }
    }

    private func setupTitleView() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "logoMini"))
        navigationItem.titleView = titleImageView
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NewsCell.reuseId)
        
        let nib = UINib(nibName: "NewsFeedCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: NewsCell.reuseId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "goToTheDetailNews" {
            if let vc = segue.destination as? DetailNewsViewController, let selectedNews = self.selectedNews {
                vc.selectedNews = selectedNews
            }
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: LookNewsViewController) {
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNews = news[indexPath.row]
        
        performSegue(withIdentifier: "goToTheDetailNews", sender: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId, for: indexPath) as! NewsCell

        let new = self.news[indexPath.row]
        cell .configure(withNews: new)
        return cell
    }
}
