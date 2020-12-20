import UIKit

class FilmEntityCell: UITableViewCell {
	
	@IBOutlet weak var filmImage: UIImageView!
	
	@IBOutlet weak var filmTitle: UILabel!

	@IBOutlet weak var year: UILabel!

	var index: Int = 0
}
