import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {super.viewDidLoad()}

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}

    // maps 1 -> 8:30, 2 -> 9:00, etc.
    func displayTime(row : Int) -> String {
        var hours = (15 + row) / 2
        if (hours > 12) {hours -= 12} // we could also have military time mode lol
        if (row % 2 == 1) {return String(hours) + ":00"} // odd rows are on the hour
        else { return String(hours) + ":30"} // even rows are half hours
    }

    // I think range of classes is 8:00am to 9:15pm
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return 168}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ScheduleCell
        cell.classInfo.text = ""
        cell.backgroundColor = UIColor.lightGray
        if (indexPath.row == 1) {cell.classInfo.text = "Mon."}
        if (indexPath.row == 2) {cell.classInfo.text = "Tues."}
        if (indexPath.row == 3) {cell.classInfo.text = "Wed."}
        if (indexPath.row == 4) {cell.classInfo.text = "Thurs."}
        if (indexPath.row == 5) {cell.classInfo.text = "Fri."}
        if (indexPath.row >= 1 && indexPath.row <= 5) {cell.backgroundColor = UIColor.red}
        
        // leftmost column is 0 mod 6
        if (indexPath.row % 6 == 0) {
            cell.classInfo.text = displayTime(row: indexPath.row/6)
            cell.backgroundColor = UIColor.red
        }
        
        if (indexPath.row == 0) { // upper left cell should be empty
            cell.classInfo.text = ""
            cell.backgroundColor = UIColor.white
        }
        
        if (indexPath.row == 70 || indexPath.row == 76) {cell.classInfo.text = "calculus"}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
