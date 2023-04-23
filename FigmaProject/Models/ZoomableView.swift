import UIKit

class ZViewController: UIViewController, UIScrollViewDelegate {

    var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a UIScrollView that will contain the UIView
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self

        // Set the content size of the scroll view
        scrollView.contentSize = contentView.bounds.size

        // Set the minimum and maximum zoom scales of the scroll view
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0

        // Add the content view to the scroll view
        scrollView.addSubview(contentView)

        // Add the scroll view to the main view
        view.addSubview(scrollView)
    }

    // Implement UIScrollViewDelegate method to provide view to zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
}
