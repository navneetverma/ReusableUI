//
//  TimePickerView.swift
//  
//
//  Created by Rob Visentin on 11/17/20.
//

#if canImport(UIKit)
import UIKit

public class TimePickerView: UIControl {

    public struct Time {
        public var hour: Int    // [0, 23]
        public var minute: Int  // [0, 59]

        public init(hour: Int, minute: Int) {
            self.hour = max(0, hour % 24)
            self.minute = max(0, minute % 60)
        }
    }

    // MARK: - Properties

    public var minuteInterval: Int {
        get {
            return datePicker.minuteInterval
        }
        set {
            datePicker.minuteInterval = newValue
        }
    }

    public var locale: Locale? {
        get {
            return datePicker.locale
        }
        set {
            datePicker.locale = newValue
        }
    }

    public var selectedTime: Time {
        get {
            let components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
            return Time(hour: components.hour ?? 0, minute: components.minute ?? 0)
        }
        set {
            if let date = Calendar.current.date(from: DateComponents(
                calendar: Calendar.current,
                hour: newValue.hour,
                minute: newValue.minute
            )) {
                datePicker.date = date
            }
        }
    }

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.minuteInterval = 5

        if #available(iOS 13, *) {
            picker.overrideUserInterfaceStyle = .light
        }

        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }

        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero)

        layoutMargins = .zero
        insetsLayoutMarginsFromSafeArea = false

        addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            datePicker.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])

        selectedTime = Time(hour: 9, minute: 0)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func datePickerValueChanged() {
        sendActions(for: .valueChanged)
    }

}

// MARK: - LocalizedStringConvertible

extension TimePickerView.Time: LocalizedStringConvertible {

    /// Returns the time as e.g. 1:30 PM or 13:30, depending on locale.
    public var localizedDescription: String? {
        let components = DateComponents(calendar: Calendar.current, hour: hour, minute: minute)
        return Calendar.current.date(from: components).map {
            DateFormatter.localizedString(from: $0, dateStyle: .none, timeStyle: .short)
        }
    }

}
#endif
