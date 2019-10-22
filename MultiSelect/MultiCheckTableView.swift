//
//  MultiCheckTableView.swift
//  MultiSelect
//
//  Created by user on 13/09/19.
//  Copyright © 2019 Contus. All rights reserved.
//

import Foundation
import UIKit
struct MultiSelectData {
    var multiSelectChoiceString: String? = ""
    var isSelected: Bool?
    init(multiSelectChoiceString: String? = "", isAlreadySelected: Bool? = false) {
        self.multiSelectChoiceString = multiSelectChoiceString
        self.isSelected = isAlreadySelected
    }
}
class MultiCheckTableView: UIViewController, UISearchBarDelegate {
    @IBOutlet var popUpViewContainer: UIView!
    @IBOutlet var popUpHeadingContainer: UIView!
    @IBOutlet var popUpHeading: UILabel!
    @IBOutlet var multiSelectTableView: UITableView!
    @IBOutlet var popUpFooterViewContainer: UIView!
    @IBOutlet var popUpCancelButton: UIButton!
    @IBOutlet var popUpOkButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    var dataSelection: (_ data: [MultiSelectData]) -> Void = { _ in }
    var tableViewData: [MultiSelectData] = [MultiSelectData]()
    var tableViewAllData: [MultiSelectData] = [MultiSelectData]()
    var tableViewSearchedData: [MultiSelectData] = [MultiSelectData]()
    var multiSelectCheckedImage: UIImage? = UIImage(named: "ic_checkbox_selected")
    var multiSelectUnCheckedImage: UIImage? = UIImage(named: "ic_checkbox_unselected")
    var selectionStyle: UITableViewCell.SelectionStyle? = UITableViewCell.SelectionStyle.none
    var separatorStyle: UITableViewCell.SeparatorStyle? = UITableViewCell.SeparatorStyle.singleLine
    var currentImage: UIImage?
    var selectionLimit: Int? = 3
    var currentSelectionCount: Int? = 0
    var isSingleSelect: Bool? = false
    var isSearching: Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAllData = tableViewData
        multiSelectTableView.allowsMultipleSelection = true
        searchBar.delegate = self
        currentImage = multiSelectUnCheckedImage
        multiSelectTableView.separatorStyle = separatorStyle!
        if isSingleSelect! {
            popUpFooterViewContainer.isHidden = true
        } else {
            popUpFooterViewContainer.isHidden = false
        }
        if selectionLimit == 0 {
            selectionLimit = tableViewData.count
        }
        for data in tableViewData {
            if data.isSelected! {
                currentSelectionCount = currentSelectionCount! + 1
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func popUpCancelButtonAction(_ sender: Any) {
        dataSelection = { _ in }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func popUpOkButtonAction(_ sender: Any) {
        dataSelection(tableViewData.filter { $0.isSelected == true })
        self.dismiss(animated: true, completion: nil)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            tableViewData = tableViewAllData
            multiSelectTableView.reloadData()
        } else {
            tableViewData = tableViewAllData.filter({($0.multiSelectChoiceString?.lowercased().contains(searchText.lowercased()))!})
            isSearching = true
            multiSelectTableView.reloadData()
        }
    }
    func updateTableViewAllData(for filterIndex: Int, isSelected boolValue: Bool) -> Void {
        for i in (0..<tableViewAllData.count) {
            if tableViewAllData[i].multiSelectChoiceString == tableViewData[filterIndex].multiSelectChoiceString {
                tableViewAllData[i].isSelected = boolValue
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let currentView = touch?.location(in: self.view) else { return }
        if !self.popUpViewContainer.frame.contains(currentView) {
            self.dismiss(animated: true, completion: nil)
        } else {
            print("Tapped inside the view")
        }
    }
    deinit {
        print("MultiCheckTableView Deallocated")
    }
}
extension MultiCheckTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSingleSelect! {
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleSelectOptionContainerCell") as? SingleSelectOptionContainerCell
            cell?.singleSelectChoiceLabel?.text = tableViewData[indexPath.row].multiSelectChoiceString
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MultiCheckOptionContainerCell
            cell?.optionLabel?.text = tableViewData[indexPath.row].multiSelectChoiceString
            if tableViewData[indexPath.row].isSelected! {
                cell?.optionImageView?.image = self.multiSelectCheckedImage
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                cell?.optionImageView?.image = self.multiSelectUnCheckedImage
            }
            cell?.selectionStyle = self.selectionStyle!
            return cell ?? UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSingleSelect! {
            tableViewData[indexPath.row].isSelected = true
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            dataSelection(tableViewData.filter { $0.isSelected == true })
            self.dismiss(animated: true)
        } else {
            if currentSelectionCount! < selectionLimit! {
                tableViewData[indexPath.row].isSelected = true
                updateTableViewAllData(for: indexPath.row, isSelected: true)
                tableView.reloadRows(at: [indexPath], with: .none)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                print("Row Selected::", indexPath.row)
                currentSelectionCount = currentSelectionCount! + 1
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
                print("You can do maximum \(selectionLimit!) selections!")
            }
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if currentSelectionCount! > 0 {
            currentSelectionCount = currentSelectionCount! - 1
        }
        if tableViewData[indexPath.row].isSelected! {
            updateTableViewAllData(for: indexPath.row, isSelected: false)
            tableViewData[indexPath.row].isSelected = false
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        print("Row Deselected::", indexPath.row)
    }
}
