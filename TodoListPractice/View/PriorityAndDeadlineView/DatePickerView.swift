import UIKit

class DatePickerView: UIView {
    // MARK: - Properties
    private let datePicker = UIDatePicker()
    var onDateSelected: ((Date) -> Void)?

    // MARK: - Overriden funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views
    func setupView() {
        self.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.date = Date().advanced(by: 3600 * 24)
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    // MARK: - Action funcs
    @objc
    func dateChanged() {
        onDateSelected?(datePicker.date)
    }
}
