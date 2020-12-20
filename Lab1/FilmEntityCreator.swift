import UIKit

class FilmEntityCreator: UIView {
	var FilmsData: FilmEntities?
	var FilmsTableView: UITableView?
	var FilmsTableViewController: ViewController?

	@IBOutlet weak var title: UITextField!
	@IBOutlet weak var date: UITextField!

	@IBAction func AddFilm(_ sender: Any) {

		let dateIsValid = date.text?.allSatisfy({
			$0.isNumber
		})

		if title.hasText && date.hasText && dateIsValid! {
			let userFilm = FilmEntity(title: title.text!, year: date.text!, imdbID: "userID", type: "userFilm", poster: "Poster_08.jpg")
			if FilmsData!.isFiltered! {
				FilmsData?.filtered!.append(userFilm)
			}
			FilmsData?.search.append(userFilm)
			FilmsTableViewController!.emptyNote.isHidden = FilmsData?.filtered?.count != 0 && FilmsData?.search.count != 0
			FilmsTableView?.reloadData()
		}
	}
}
