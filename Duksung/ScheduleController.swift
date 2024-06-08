
import UIKit
import Kanna
import Alamofire

class ScheduleController: UITableViewController {
    var scheduleItem: [String] = []
    var scheduleDate: [String] = []
    var scheduleUrl: [String] = []
    var bookmarkCounts: [String: Int] = [:]

    func getSchedule() -> Void {
        let urlString = "https://www.paxnet.co.kr/stock/sise/totalRanking?wlog_rpax=User_rank"
        AF.request(urlString).responseString(encoding: .utf8) { response in
            switch response.result {
            case .success(let htmlStr):
                self.parseHTML(str: htmlStr)
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction func refresh(_ sender: Any) {
        self.scheduleItem.removeAll()
        self.scheduleUrl.removeAll()
        self.scheduleUrl.removeAll()
        self.getSchedule()
    }
    
    @IBAction func bookmarks(_ sender: Any) {
        let sortedBookmarks = bookmarkCounts.sorted { $0.value > $1.value }
        let bookmarkMessages = sortedBookmarks.map { "\($0.key)" }
        let alert = UIAlertController(title: "내 종목검색랭킹", message: bookmarkMessages.joined(separator: " "), preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func parseHTML(str: String) -> Void {
        let document = try? Kanna.HTML(html: str, encoding: .utf8)
        guard let doc = document else {
            return
        }
        for item in doc.xpath("//tbody/tr/td/a") {
            if let text = item.text, let href = item["href"] {
                scheduleItem.append(text)
                scheduleUrl.append(href)
            }
        }
        for date in doc.xpath("//tr/td[4]/span/text()") {
            if let text = date.text {
                scheduleDate.append(text)
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSchedule()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = scheduleItem[indexPath.row]
        cell.detailTextLabel?.text = scheduleDate[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = scheduleItem[indexPath.row]
        if bookmarkCounts[selectedItem] != nil {
            bookmarkCounts[selectedItem]! += 1
        } else {
            bookmarkCounts[selectedItem] = 1
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        guard let destController = segue.destination as? DetailController else {
            return
        }
        let index = tableView.indexPathForSelectedRow?.row
        destController.urlString = scheduleUrl[index!]
    }
}
