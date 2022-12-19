//
//  DropDownTagPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import Foundation

protocol DropDownTagPresenterProtocol {
    init(view: DropDownTagViewControllerProtocol)
    func getCurrentTags() -> [String]
    func getCustomTags() -> [String]
    func getUsedTags() -> [String]
    func getCurrentTags2() -> [String]
    func getCustomTags2() -> [String]
    func getUsedTags2() -> [String]
    //func configureDetailCell(_ cell: DropDownMenuTableViewCell, index: Int)
//    func add(tag: String, index: Int)
//    func remove(tag: String, index: Int)
    
}

class DropDownTagPresenter: DropDownTagPresenterProtocol {
    private weak var view: DropDownTagViewControllerProtocol?
    
    var currentTags: [String] = ["tag1", "tag2", "tag3", "apple", "google", "facebook"]
    var customUserTags: [String] = ["custom1"] {
        didSet {
            print(customUserTags)
        }
    }
    var currentTags2: [String] = ["tag12", "tag22", "tag32", "apple2", "google2", "facebook2"]
    var customUserTags2: [String] = ["custom12"] {
        didSet {
            print(customUserTags2)
        }
    }
    var alreadyUsedTags1: [String] = ["tag3"]
    var alreadyUsedTags2: [String] = ["tag32"]
    
    var filteredTags: [String] = []
    var filteredTags2: [String] = []
    
    private let isCustomTagsEnabled = true //tags customization option change here
    private let isCustomTagsEnabled2 = false
    
    required init(view: DropDownTagViewControllerProtocol) {
        self.view = view
        // apply current tags here
    }
    
//    func configureFilteredTag(tag: String, index: Int) {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            if filteredTags.contains(tag) {
//                filteredTags = filteredTags.filter {$0 != tag}
//            } else {
//                filteredTags.append(tag)
//            }
//        case .list:
//            if filteredTags2.contains(tag) {
//                filteredTags2 = filteredTags2.filter {$0 != tag}
//            } else {
//                filteredTags2.append(tag)
//            }
//        case .none:
//            print("NoCell")
//        }
//
//      //  view?.updateTableViewLayouts()
//    }
    
//    func add(tag: String, index: Int) {
//
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            if currentTags.contains(tag) {
//                if filteredTags.contains(tag) {
//                    return
//                } else {
//                    filteredTags.append(tag)
//                }
//            } else {
//                addCustomTag(tag: tag, index: index)
//            }
//        case .list:
//            if currentTags2.contains(tag) {
//                if filteredTags2.contains(tag) {
//                    return
//                } else {
//                    filteredTags2.append(tag)
//                }
//            } else {
//                addCustomTag(tag: tag, index:  index)
//            }
//        case .none:
//            print("NoCell")
//        }
//       // view?.updateTableViewLayouts()
//    }
    
//    func remove(tag: String, index: Int) {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            if currentTags.contains(tag) {
//                if filteredTags.contains(tag) {
//                    filteredTags = filteredTags.filter {$0 != tag}
//                } else {
//                    return
//                }
//            } else {
//                removeCustomTag(tag: tag, index: index)
//            }
//        case .list:
//            if currentTags2.contains(tag) {
//                if filteredTags2.contains(tag) {
//                    filteredTags2 = filteredTags2.filter {$0 != tag}
//                } else {
//                    return
//                }
//            } else {
//                removeCustomTag(tag: tag, index: index)
//            }
//        case .none:
//            print("NoCell")
//        }
//        view?.updateTableViewLayouts()
//    }
    
//    func addCustomTag(tag: String, index: Int) {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            if customUserTags.contains(tag) {
//                return
//            } else {
//                customUserTags.append(tag)
//            }
//        case .list:
//            if customUserTags2.contains(tag) {
//                return
//            } else {
//                customUserTags2.append(tag)
//            }
//        case .none:
//            print("NoCell")
//        }
//    }
    
//    func removeCustomTag(tag: String, index: Int) {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            if customUserTags.contains(tag) {
//                customUserTags = customUserTags.filter {$0 != tag}
//            } else {
//                return
//            }
//        case .list:
//            if customUserTags2.contains(tag) {
//                customUserTags2 = customUserTags2.filter {$0 != tag}
//            } else {
//                return
//            }
//        case .none:
//            print("NoCell")
//        }
//
//    }
    
//    func getCurrentTags(index: Int) -> [String] {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            return currentTags
//        case .list:
//            return currentTags2
//        case .none:
//            print("NoCell")
//            return []
//        }
//    }
    func getCurrentTags() -> [String] {
            return currentTags
    }
    
    func getCustomTags() -> [String] {
            return customUserTags
    }
    func getUsedTags() -> [String] {
            return alreadyUsedTags1
    }
    
    func getCurrentTags2() -> [String] {
            return currentTags2
    }
    
    func getCustomTags2() -> [String] {
            return customUserTags2
    }
    func getUsedTags2() -> [String] {
            return alreadyUsedTags2
    }
    
//    func getFilteredTags(index: Int) -> [String] {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            if isCustomTagsEnabled {
//                return filteredTags + customUserTags
//            } else {
//                return filteredTags
//            }
//        case .list:
//            if isCustomTagsEnabled2 {
//                return filteredTags2 + customUserTags2
//            } else {
//                return filteredTags2
//            }
//        case .none:
//            print("NoCell")
//            return []
//        }
//    }
    
//    func configureDetailCell(_ cell: DropDownMenuTableViewCell, index: Int) {
//        let customization: Bool
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            customization = isCustomTagsEnabled
//        case .list:
//           customization = isCustomTagsEnabled2
//        case .none:
//            customization = false
//        }
//        cell.cellInit(tags: getFilteredTags(index: index), enableCustomTags: customization)
//    }
}
