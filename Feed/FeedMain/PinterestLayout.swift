

import UIKit

//높이를 요청하는 메소드 구현
protocol PinterestLayoutDelegate: class {
  // 1. Method to ask the delegate for the height of the image
  func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  //1. Pinterest Layout Delegate
  weak var delegate: PinterestLayoutDelegate!
  
  //2. Configurable properties // 칼럼 패딩값
  fileprivate var numberOfColumns = 2
  fileprivate var cellPadding: CGFloat = 6
  
  //3. Array to keep a cache of attributes. 연산된속성을 캐시하는 배열
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  
  //4. Content height and size 컨텐츠 사이즈를 저장하기위해 선언한 속성
  fileprivate var contentHeight: CGFloat = 0 //사진추가시 증가
  // 컬렉션뷰의 넓이와 inset기반으로 연산된다.
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  //5. collection view의 콘텐츠 사이즈를 반환하는 매소드인 collectionViewContentSize의 재정의 입니다. 사이즈를 연산하는 이전 단계의 contentWidth, contentHeight 두개 모두 사용합니다.
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    // 1. Only calculate once
    // cache가 비어 있고 collection view가 존재할때만 레이아웃 속성을 연산합니다.
    guard cache.isEmpty == true, let collectionView = collectionView else {
      return
    }
    // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
    //열 넓이 기반 모든 컬럼에 대해 x좌표와 함께 XOffset 배열을 채우고 선언 합니다.
    //YOffset배열은 모든 열에 대한 y위치를 추적합니다.
    //각 열의 첫번째 항목의 offset 이기때문에 YOffset의 각 값을 0으로 초기화 합니다.
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    for column in 0 ..< numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
    // 3. Iterates through the list of items in the first section
    // 이 단 하나의 색션만 있는 레이아웃은 첫번째 색션의 모든 아이템을 반복합니다.
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      
      let indexPath = IndexPath(item: item, section: 0)
      
      // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
      // 여기서 프레임 계산을 수행합니다. 넓이는 이전에 연산한 CellWidth 이고 Cell들 사이의 패딩이 제거됩니다.
      // 사진의 높이를 위해 delegate에게 요청하고 이 높이를 기반으로 frame height를 연산하고 상단과 하단을 위해 cellPadding을 미리 정의합니다.
      // 그후 현재 열의 x, y offset과 결합하여 속성에 의해 사용되는 insetFrame을 생성 합니다.
      let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
      // UICollectionViewLayoutAttributes 인스턴스를 생성하고 insetFrame을 사용하여 자체 프레임을 설정하고 attributes를 캐시로 추가합니다.
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      // 6. Updates the collection view content height
      // 새롭게 계산된 프레임으로 여기기 위해 contentHeight를 확장합니다.
      // 그후 프레임 기반 현재 열에 대한 yOffset를 진행 시킵니다. 마지막으로 다음 아이템을 다음 열로 위치시킵니다.
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
}
