////
///  ColumnToggleCell.swift
//

public class ColumnToggleCell: UICollectionViewCell {

    static let reuseIdentifier = "ColumnToggleCell"

    public var isGridView: Bool = false {
        didSet {
            gridButton.selected = isGridView
            listButton.selected = !isGridView
        }
    }
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var listButton: UIButton!

    weak var columnToggleDelegate: ColumnToggleDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.greyF2()
        gridButton.setImages(.Grid)
        listButton.setImages(.List)
        gridButton.backgroundColor = .greyF2()
        listButton.backgroundColor = .greyF2()
    }

    @IBAction func gridTapped(sender: UIButton) {
        isGridView = true
        columnToggleDelegate?.columnToggleTapped(isGridView)
    }

    @IBAction func listTapped(sender: UIButton) {
        isGridView = false
        columnToggleDelegate?.columnToggleTapped(isGridView)
    }

}
