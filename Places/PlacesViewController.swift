import UIKit

class PlacesViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    var objectPlaces = Places()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectPlaces.places = [Dictionary<String, String>()]
        objectPlaces.activePlace = -1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let loadPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            objectPlaces.places = loadPlaces
        }
        
        if objectPlaces.places.count == 1 && objectPlaces.places[0].count == 0 {
            
            objectPlaces.places.remove(at: 0)
            objectPlaces.places.append(["name": "Montréal",
                           "lat": "45.495293",
                           "lon": "-73.594929"])
            UserDefaults.standard.set(objectPlaces.places, forKey: "places")
        }
        
        objectPlaces.activePlace = -1
        table.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectPlaces.places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")

        if objectPlaces.places[indexPath.row]["name"] != nil {
        
            cell.textLabel?.text = objectPlaces.places[indexPath.row]["name"]
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        objectPlaces.activePlace = indexPath.row
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let destination = segue.destination as! ViewController
            destination.objectPlaces = objectPlaces
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.objectPlaces.places.remove(at: indexPath.row)
            UserDefaults.standard.set(self.objectPlaces.places, forKey: "places")
        }
        table.reloadData()
    }

}
