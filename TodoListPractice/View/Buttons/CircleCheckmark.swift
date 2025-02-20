import UIKit

class CircleCheckmark: UIButton {
    func setAppearance(isDone: Bool, highPriority: Bool) {
        translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Setup checkmark button appearance
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let doneImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration)
        let undoneImage = UIImage(systemName: "circle", withConfiguration: configuration)

        if isDone {
            setImage(doneImage?.withTintColor(
                .systemGreen,
                renderingMode: .alwaysOriginal),
                     for: .normal
            )
        } else if highPriority {
            setImage(undoneImage?.withTintColor(
                .systemRed,
                renderingMode: .alwaysOriginal),
                     for: .normal
            )
        } else {
            setImage(undoneImage?.withTintColor(
                ColorsExtensions.supportLight,
                renderingMode: .alwaysOriginal),
                     for: .normal
            )
        }
        if let img = doneImage {
            self.widthAnchor.constraint(equalToConstant: img.size.width).isActive = true
        }
    }
}
