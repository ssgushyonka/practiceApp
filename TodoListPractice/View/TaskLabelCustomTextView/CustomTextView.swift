import Foundation
import UIKit

final class CustomTextView: UITextView, UITextViewDelegate {
    // MARK: - UI Components
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "What to do?"
        label.textColor = ColorsExtensions.lightTertiary
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Overriden funcs
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        self.backgroundColor = .white
        self.textColor = .black
        self.layer.cornerRadius = 16
        self.font = .systemFont(ofSize: 17)
        self.layer.masksToBounds = true
        self.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        addSubview(placeHolderLabel)
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Delegate funcs
    func textViewDidChange( _: UITextView) {
        placeHolderLabel.isHidden = !self.text.isEmpty
    }

    func textViewDidBeginEditing( _: UITextView) {
        placeHolderLabel.isHidden = true
    }

    func textViewDidEndEditing( _: UITextView) {
        placeHolderLabel.isHidden = !self.text.isEmpty
    }
}
