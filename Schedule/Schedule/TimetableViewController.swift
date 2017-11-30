import UIKit
struct Course: Hashable { // Hashing is necessary for sets
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
    
    var hashValue: Int {return name.hashValue}
    static func == (lhs: Course, rhs: Course) -> Bool {return lhs.name == rhs.name}
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        for i in 1...3 { // colors repeat every 6 courses with varying alpha
            colors.append(UIColor(red:0, green:1, blue:0, alpha:1/CGFloat(i)))
            colors.append(UIColor(red:0, green:0, blue:1, alpha:1/CGFloat(i)))
            colors.append(UIColor(red:1, green:0, blue:0, alpha:1/CGFloat(i)))
            colors.append(UIColor(red:1, green:1, blue:0, alpha:1/CGFloat(i)))
            colors.append(UIColor(red:1, green:0, blue:1, alpha:1/CGFloat(i)))
            colors.append(UIColor(red:0, green:1, blue:1, alpha:1/CGFloat(i)))
        }
        updateDict()
        super.viewDidLoad()
        scheduleView.dataSource = self
        scheduleView.delegate = self
        classDetailsView.backgroundColor = UIColor.lightGray
        classDetailsView.isHidden = true
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    var courses: Set<Course> = [Course(name: "Hello Stats", startTime: 2, duration: 3, weekday: [1, 3], instructor: "Spitznagel", credits: 3, seats: 40, final: true, building: "Cupples", department: "Math"), Course(name: "new 1", startTime: 4, duration: 3, weekday: [1, 3], instructor: "Wrighton", credits: 4, seats: 90, final: false, building: "Eads", department: "English")]
    var colors = [UIColor]() // supports 18 courses
    var cellDict = [Int:(course: Course, color: UIColor, displayName: Bool)]() // 3 pieces of info for each cell
    var currentCourse = Course(name: "", startTime: 0, duration: 0, weekday: [], instructor: "", credits: 0, seats: 0, final: true, building: "", department: "") // temporary initialization
    
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
    @IBAction func dropCourse(_ sender: UIButton) {
        courses.remove(currentCourse)
        cellDict = [:]
        updateDict()
        self.scheduleView.reloadData()
        classDetailsView.isHidden = true
    }
    
    func updateDict() { // update the dictionary with the course set
        var k = 0
        for course in courses {
            for day in course.weekday {
                let block = 6*course.startTime + day + 7
                let conflict = Course(name: "Conflict!", startTime: course.startTime, duration: course.duration, weekday: course.weekday, instructor: "", credits: 0, seats: 0, final: true, building: "", department: "")
                if (cellDict[block] != nil) {
                    cellDict.updateValue((conflict, UIColor.black, true), forKey: block) // if there is something already here, color black for conflict
                } else {
                    cellDict.updateValue((course, colors[k], true), forKey: block) // first block on each day displays name
                }
                for i in 1...course.duration-1 {
                    if (cellDict[block+6*i] != nil) {
                        cellDict.updateValue((conflict, UIColor.black, false), forKey: block+6*i) // if there is something already here, color black for conflict
                    } else {
                    cellDict.updateValue((course, colors[k], false), forKey: block+6*i)} // rest do not
                }
            }
            k += 1 // go to next color
            if (k == 18) {k = 0}
        }
    }
    
    func displayTime(row : Int) -> String { // converts a row to a time
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
            cell.classInfo.text = "WUSTL"
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (cellDict[indexPath.row] != nil) {
            classDetailsView.isHidden = false
            currentCourse = cellDict[indexPath.row]!.course
            name.text = "Name: " + currentCourse.name
            instructor.text = "Instructor: " + currentCourse.instructor
            credits.text = "Credits: " + String(currentCourse.credits)
            seats.text = "Seats: " + String(currentCourse.seats)
            if (currentCourse.final) {final.text = "Final: Yes"}
                else {final.text = "Final: No"}
            building.text = "Building: " + currentCourse.building
            department.text = "Department: " + currentCourse.department
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 6 columns per row
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(5)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(6)).rounded(.down)
        return CGSize(width: itemWidth, height: 36)
    }
}
