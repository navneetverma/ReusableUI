//
//  MenuItemsViewController.swift
//  
//
//  Created by Siddarth Gandhi on 6/2/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit


public protocol PickerMenuOption {
    var rawValue: String { get }
}

public protocol PickerMenuDelegate: AnyObject {
    func PickerMenu(didSelect option: PickerMenuOption)
}

protocol MenuItemsViewControllerDelegate: AnyObject {
    func menuOptionsPresented()
    func menuOptionsHidden()
    func select(option: PickerMenuOption)
}

final class MenuItemsPicker: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    weak var pickerDelegate: MenuItemsViewControllerDelegate?
    
    private var options: [PickerMenuOption]
    private var selectedOption: PickerMenuOption?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        let items = [flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        return toolbar
    }()
    
    
    // MARK: - Lifecycle
    
    init(options: [PickerMenuOption], selectedOption: PickerMenuOption?) {
        self.options = options
        self.selectedOption = selectedOption
        super.init(frame: .zero)
        inputView = pickerView
        inputAccessoryView = doneToolbar
    }
    
    required init?(coder: NSCoder) { fatalError("init(menuTitle:options:selectedOption:) has not been implemented") }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            pickerDelegate?.menuOptionsPresented()
        } else {
            pickerDelegate?.menuOptionsHidden()
        }
    }
    
    // MARK: - UIPickerViewDelegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].rawValue ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerDelegate?.select(option: options[row])
        
    }
    
    
    // MARK: - Actions

    @objc private func doneButtonTapped() {
        pickerDelegate?.menuOptionsHidden()

        resignFirstResponder()
    }
    
    func showPicker() {
        becomeFirstResponder()
    }
}

#endif
