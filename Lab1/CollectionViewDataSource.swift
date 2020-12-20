import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {

	var Images: [UIImage]?

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Images!.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! CollectionViewCell
		cell.PictureView.image = Images![indexPath.row]
		return cell
	}

}
