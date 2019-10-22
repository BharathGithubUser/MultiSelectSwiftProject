//
//  ViewController.swift
//  MultiSelect
//
//  Created by user on 13/09/19.
//  Copyright © 2019 Contus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var showPopUpButton: AutoResizingButton!
    var multiSelectVC: MultiCheckTableView?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    @IBAction func showPopUpButtonAction(_ sender: Any) {
        // Do any additional setup after loading the view.
        multiSelectVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MultiCheckTableView") as? MultiCheckTableView
        multiSelectVC?.tableViewData = [
            MultiSelectData.init(multiSelectChoiceString: "first", isAlreadySelected:  true),
            MultiSelectData.init(multiSelectChoiceString: "second"),
            MultiSelectData.init(multiSelectChoiceString: "third"),
            MultiSelectData.init(multiSelectChoiceString: "fourt"),
            MultiSelectData.init(multiSelectChoiceString: "fifth"),
            MultiSelectData.init(multiSelectChoiceString: "sixth"),
            MultiSelectData.init(multiSelectChoiceString: "seventh"),
            MultiSelectData.init(multiSelectChoiceString: "eighth"),
            MultiSelectData.init(multiSelectChoiceString: "ninth"),
            MultiSelectData.init(multiSelectChoiceString: "tenth"),
            MultiSelectData.init(multiSelectChoiceString: "eleventh"),
            MultiSelectData.init(multiSelectChoiceString: "asfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasfasfdasfasdfasdfasdfasdfasf")
        ]
        multiSelectVC?.dataSelection = { multiselecteddata in
            for data in multiselecteddata {
                print((data.multiSelectChoiceString) ?? "Unable To Display Data", (data.isSelected)!)
                self.showPopUpButton.setTitle(data.multiSelectChoiceString, for: .normal)
            }
            self.multiSelectVC = nil
        }
        multiSelectVC?.isSingleSelect = false
        multiSelectVC?.separatorStyle = UITableViewCell.SeparatorStyle.none
        multiSelectVC?.title = "Choose Data"
        multiSelectVC?.modalPresentationStyle = .overCurrentContext
        multiSelectVC?.modalTransitionStyle = .crossDissolve
        multiSelectVC?.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        self.present(multiSelectVC!, animated: true)
    }
}

