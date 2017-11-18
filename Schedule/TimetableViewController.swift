import UIKit
struct Course {
    var name: String
    var startTime: Int // 0 <-> 8:00, 1 <-> 8:30...
    var duration: Int // 1 unit <-> 30 min
    var weekday: Set<Int> // 0 <-> Monday, ..., 4 <-> Friday
    var instructor: String
    var credits: Int
    var seats: Int
    var final: Bool
    var building: String
    var department: String
    init(name: String, startTime: Int, duration: Int, weekday: Set<Int>, instructor: String, credits: Int, seats: Int, final: Bool, building: String, department: String) {
        self.name = name
        self.startTime = startTime
        self.duration = duration
        self.weekday = weekday
        self.instructor = instructor
        self.credits = credits
        self.seats = seats
        self.final = final
        self.building = building
        self.department = department
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    override func viewDidLoad() {
        var k = 0
        for course in courses {
            for day in course.weekday {
                let block = 6*course.startTime + day + 7
                cellDict.updateValue((course, colors[k], true), forKey: block) // first block on each day displays name
                for i in 1...course.duration-1 {cellDict.updateValue((course, colors[k], false), forKey: block+6*i)} // rest do not
            }
            k += 1
        }
        super.viewDidLoad()
        classDetailsView.isHidden = true
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    let courses = [Course(name: "Intermediate Stats", startTime: 2, duration: 2, weekday: [0, 2, 4], instructor: "Spitznagel", credits: 3, seats: 40, final: true, building: "Cupples", department: "Math"), Course(name: "Writing 1", startTime: 5, duration: 3, weekday: [1, 3], instructor: "Wrighton", credits: 4, seats: 90, final: false, building: "Eads", department: "English"), Course(name: "CSE 131", startTime: 9, duration: 2, weekday: [0, 2, 4], instructor: "Cytron", credits: 1, seats: 300, final: true, building: "Urbauer", department: "Computer Science")]
    let colors = [UIColor.blue, UIColor.yellow, UIColor.green, UIColor.purple, UIColor.cyan, UIColor.white, UIColor.brown]
    @IBOutlet weak var scheduleView: UICollectionView!
    @IBOutlet weak var classDetailsView: ClassDetailsView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var instructor: UILabel!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var seats: UILabel!
    @IBOutlet weak var final: UILabel!
    @IBOutlet weak var building: UILabel!
    @IBOutlet weak var department: UILabel!
    
    @IBAction func close(_ sender: UIButton) {classDetailsView.isHidden = true}
    var cellDict = [Int:(course: Course, color: UIColor, displayName: Bool)]()
    
    func displayTime(row : Int) -> String {
        var hours = (15 + row) / 2
        if (hours > 12) {hours -= 12}
        if (row % 2 == 1) {return String(hours) + ":00"} // odd rows are on the hour
        else { return String(hours) + ":30"} // even rows are half hours
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return 168}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ScheduleCell
        cell.backgroundColor = UIColor.lightGray
        cell.classInfo.text = ""
        if (cellDict[indexPath.row] != nil) {
            if (cellDict[indexPath.row]!.displayName) {cell.classInfo.text = cellDict[indexPath.row]!.course.name} // display name on first block
            cell.backgroundColor = cellDict[indexPath.row]!.color
        }
        if (indexPath.row == 1) {cell.classInfo.text = "Mon."}
        if (indexPath.row == 2) {cell.classInfo.text = "Tues."}
        if (indexPath.row == 3) {cell.classInfo.text = "Wed."}
        if (indexPath.row == 4) {cell.classInfo.text = "Thurs."}
        if (indexPath.row == 5) {cell.classInfo.text = "Fri."}
        if (indexPath.row >= 1 && indexPath.row <= 5) {cell.backgroundColor = UIColor.red}
        
        if (indexPath.row % 6 == 0) { // leftmost column is 0 mod 6
            cell.classInfo.text = displayTime(row: indexPath.row/6)
            cell.backgroundColor = UIColor.red
        }
        
        if (indexPath.row == 0) { // clear upper left cell
            cell.classInfo.text = ""
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (cellDict[indexPath.row] != nil) {
            classDetailsView.isHidden = false
            name.text = "Name: " + cellDict[indexPath.row]!.course.name
            instructor.text = "Instructor: " + cellDict[indexPath.row]!.course.instructor
            credits.text = "Credits: " + String(cellDict[indexPath.row]!.course.credits)
            seats.text = "Seats: " + String(cellDict[indexPath.row]!.course.seats)
            if (cellDict[indexPath.row]!.course.final) {final.text = "Final: Yes"}
                else {final.text = "Final: No"}
            building.text = "Building: " + cellDict[indexPath.row]!.course.building
            department.text = "Department: " + cellDict[indexPath.row]!.course.department
        }
    }
}
