//
//  ViewController.swift
//  Lab1
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate/*, UITableViewDataSource*/ {

	var FilmsData: FilmEntities?

	@IBOutlet weak var emptyNote: UILabel!
	@IBOutlet weak var FilmsTable: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!

	var FilmDetailView: FilmEntityDetails?
	var FilmCreatorView: FilmEntityCreator?

	func loadFilms() {

		var path = Bundle.main.path(forResource: "MoviesList", ofType: "txt")

		var contents = FileManager.default.contents(atPath: path!)

		FilmsData = try! JSONDecoder().decode(FilmEntities.self, from: contents!)
		FilmsData?.isFiltered = false

		FilmsData?.extended = [:]

		for i in 0..<FilmsData!.search.count {
			let res = FilmsData!.search[i].imdbID
			path = Bundle.main.path(forResource: res, ofType: "txt")

			if ((path) != nil) {
				contents = FileManager.default.contents(atPath: path!)

				FilmsData?.extended![res] = (try! JSONDecoder().decode(FilmEntityExtended.self, from: contents!))
			} else {
				FilmsData?.extended![res] = (FilmEntityExtended())
			}
		}

		emptyNote.isHidden = FilmsData?.filtered?.count != 0
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let filmBasicData = FilmsData!.isFiltered! ? FilmsData?.filtered![indexPath.row] : FilmsData!.search[indexPath.row]
		let key = FilmsData!.isFiltered! ? filmBasicData!.imdbID : filmBasicData!.imdbID
		let filmExtendedData = FilmsData?.extended?[key]

		FilmDetailView?.detailsText.text =
		"""
		Title: \(filmExtendedData?.Title ?? filmBasicData?.title ?? "-")

		Plot: \(filmExtendedData?.Plot ?? "-")

		Actors: \(filmExtendedData?.Actors ?? "-")

		Awards: \(filmExtendedData?.Awards ?? "-")

		Country: \(filmExtendedData?.Country ?? "-")

		Director: \(filmExtendedData?.Director ?? "-")

		Genre: \(filmExtendedData?.Genre ?? "-")

		Language: \(filmExtendedData?.Language ?? "-")

		Production: \(filmExtendedData?.Production ?? "-")

		Rated: \(filmExtendedData?.Rated ?? "-")

		Released: \(filmExtendedData?.Released ?? "-")

		Runtime: \(filmExtendedData?.Runtime ?? "-")

		Writer: \(filmExtendedData?.Writer ?? "-")

		Year: \(filmExtendedData?.Year ?? filmBasicData?.year ?? "-")

		imdb ID: \(filmExtendedData?.imdbID ?? "-")

		imdb Rating: \(filmExtendedData?.imdbRating ?? "-")

		imdb Votes: \(filmExtendedData?.imdbVotes ?? "-")
		"""

		if let path = Bundle.main.path(forResource: "Posters/\(filmBasicData?.poster ?? "Poster_08.jpg")", ofType: "") {
			let contents = FileManager.default.contents(atPath: path)
			FilmDetailView?.poster.image = UIImage(data: contents!)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		FilmDetailView = segue.destination.view as? FilmEntityDetails
		FilmCreatorView = segue.destination.view as? FilmEntityCreator
		FilmCreatorView?.FilmsTableViewController = self
		FilmCreatorView?.FilmsData = FilmsData
		FilmCreatorView?.FilmsTableView = FilmsTable
		
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		searchBar.delegate = self
		loadFilms()

		FilmsTable.dataSource = FilmsData
		FilmsTable.delegate = self as UITableViewDelegate
	}

	func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
		emptyNote.isHidden = FilmsData?.filtered?.count != 0 && FilmsData?.search.count != 0
	}

}

extension ViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		FilmsData?.isFiltered = true
		FilmsData?.filtered = FilmsData?.search.filter {
			return $0.title.starts(with: searchText)
		}
		emptyNote.isHidden = FilmsData?.filtered?.count != 0
		FilmsTable.reloadData()
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		FilmsData?.isFiltered = false
		FilmsData?.filtered = nil
		emptyNote.isHidden = FilmsData?.search.count != 0
		FilmsTable.reloadData()
	}
}

