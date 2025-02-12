import UIKit
import Foundation

class CustomTextView: UITextView, UITextViewDelegate {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "What to do?"
        label.textColor = ColorsExtensions.lightTertiary
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.backgroundColor = .white
        self.textColor = .black
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        
        addSubview(placeHolderLabel)
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
}
