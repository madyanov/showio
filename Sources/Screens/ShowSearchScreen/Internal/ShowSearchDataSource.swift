import ShowCollectionScene

final class ShowSearchDataSource {
    var shows: [ShowViewModel] = []
}

extension ShowSearchDataSource: ShowCollectionViewDataSource {
    func numberOfItems(in showCollectionView: ShowCollectionView) -> Int {
        return shows.count
    }

    func showCollectionView(_ showCollectionView: ShowCollectionView,
                            showForItemAt index: Int) -> ShowCollectionScene.ShowViewModel {

        return shows[index]
    }
}
