////
///  CategoriesSelectionViewController.swift
//

import Moya


public class CategoriesSelectionViewController: StreamableViewController, HasAppController {
    var mockScreen: Screen?
    var screen: Screen { return mockScreen ?? (self.view as! Screen) }
    var parentAppController: AppViewController?
    public var onboardingViewController: OnboardingViewController?
    public var onboardingData: OnboardingData!

    required public init() {
        super.init(nibName: nil, bundle: nil)
        streamViewController.streamKind = .AllCategories
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        let screen = Screen()
        self.view = screen
        viewContainer = screen
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        streamViewController.contentInset = UIEdgeInsetsZero
        streamViewController.selectedCategoryDelegate = self
        scrollLogic.prevOffset = streamViewController.collectionView.contentOffset
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()
    }

    override public func showNavBars(scrollToBottom: Bool) {}
    override public func hideNavBars() {}

    override public func streamViewStreamCellItems(jsonables: [JSONAble], defaultGenerator generator: StreamCellItemGenerator) -> [StreamCellItem]? {
        var items: [StreamCellItem] = []

        let header = NSAttributedString(
            primaryHeader: InterfaceString.Onboard.PickCategoriesPrimary,
            secondaryHeader: InterfaceString.Onboard.PickCategoriesSecondary
            )
        let headerCellItem = StreamCellItem(type: .TextHeader(header))
        items.append(headerCellItem)

        if let categories = jsonables as? [Category] {
            items += categories.map { StreamCellItem(jsonable: $0, type: .SelectableCategoryCard) }
        }
        return items
    }
}

extension CategoriesSelectionViewController: OnboardingStepController {
    public func onboardingWillProceed(proceedClosure: () -> Void) {
        if let
            userId = currentUser?.id,
            selection = streamViewController.collectionView.indexPathsForSelectedItems()
        where selection.count > 0 {
            let categories = selection.flatMap({ (path: NSIndexPath) -> Category? in
                return streamViewController.dataSource.jsonableForIndexPath(path) as? Category
            })

            ElloProvider.oneTimeProvider = MoyaProvider<ElloAPI>(endpointClosure: ElloProvider.endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)
            UserService().setUserCategories(userId: userId, categories: categories)
                .onSuccess { _ in
                    self.onboardingData.categories = categories
                    proceedClosure()
                }
                .onFail { _ in
                    let alertController = AlertViewController(error: InterfaceString.GenericError)
                    self.parentAppController?.presentViewController(alertController, animated: true, completion: nil)
                }
        }
        else {
            proceedClosure()
        }
    }

    public func onboardingStepBegin() {
        let prompt = NSString(format: InterfaceString.Onboard.PickTemplate, 3) as String
        onboardingViewController?.canGoNext = false
        onboardingViewController?.prompt = prompt
    }
}

extension CategoriesSelectionViewController: SelectedCategoryDelegate {
    public func categoriesSelectionChanged(selection: [Category]) {
        let selectionCount = selection.count
        let prompt: String?
        let canGoNext: Bool
        switch selectionCount {
        case 0, 1, 2:
            prompt = NSString(format: InterfaceString.Onboard.PickTemplate, 3 - selectionCount) as String
            canGoNext = false
        default:
            prompt = nil
            canGoNext = true
        }

        onboardingViewController?.prompt = prompt
        onboardingViewController?.canGoNext = canGoNext
    }
}
