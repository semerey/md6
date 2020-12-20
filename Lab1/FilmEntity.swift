import UIKit


struct FilmEntity: Decodable {

	var title: String
	var year: String
	var imdbID: String
	var type: String
	var poster: String

	static func ==(lhs: FilmEntity, rhs: FilmEntity) -> Bool {
		return lhs.title == rhs.title
	}
}

struct FilmEntityExtended: Decodable {

	var Title: String?
	var Year: String?
	var Rated: String?
	var Released: String?
	var Runtime: String?
	var Genre: String?
	var Director: String?
	var Writer: String?
	var Actors: String?
	var Plot: String?
	var Language: String?
	var Country: String?
	var Awards: String?
	var Poster: String?
	var imdbRating: String?
	var imdbVotes: String?
	var imdbID: String?
	var Production: String?
}

class FilmEntities: NSObject, Decodable, UITableViewDataSource {
	var search: [FilmEntity]
	var extended: [String: FilmEntityExtended]?

	var filtered: [FilmEntity]?
	var isFiltered: Bool?

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltered! {
			return self.filtered!.count
		} else {
			return self.search.count
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "FilmEntityCell", for: indexPath) as! FilmEntityCell
		let source: [FilmEntity]! = !isFiltered! ? self.search : self.filtered
		let path = "Posters/\(source[indexPath.row].poster)"
		if let path = Bundle.main.path(forResource: path, ofType: "") {
			let contents = FileManager.default.contents(atPath: path)
			cell.filmImage.image = UIImage(data: contents!)
		}
		cell.filmTitle.text = source[indexPath.row].title
		cell.year.text = source[indexPath.row].year
		(cell as FilmEntityCell).index = indexPath.row
		return cell
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete {
			if isFiltered! {
				let index = search.firstIndex(where: {
					film in return film == filtered![indexPath.row]
				})
				search.remove(at: index!)
				extended?.removeValue(forKey: filtered![indexPath.row].imdbID)
				filtered?.remove(at: indexPath.row)
			} else {
				extended?.removeValue(forKey: search[indexPath.row].imdbID)
				search.remove(at: indexPath.row)
			}
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
		}
	}

}
