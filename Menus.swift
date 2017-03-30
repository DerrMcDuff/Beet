//
//  Menus.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-29.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import MediaPlayer

protocol Option {
    
    var mapping:[Buttons:PrimaryActions] {get}
    
    var type: StateType {get set}
    var name: String {get set}
    var parent: Option? {get set}
    var extraPanel:Option? {get set}
    var selectedRow: Int {get set}
    
    func add(extraPanel eP: Option)
    func getNumberOfRow() -> Int
    func setParent(p: Option)
    func getContent(at i: Int) -> Any?
    func getContent() -> [Any]
    func getInfos(at i: Int) -> [String]
    
}

class Setting<E>: Option {
    
    var mapping:[Buttons:PrimaryActions] = [:]
    var name: String
    var value: E
    var possibleValues:[E]
    var parent: Option?
    var type: StateType = StateType.SettingCell
    var extraPanel:Option?
    var selectedRow: Int = 0
    
    init(_ n:String, value:E ,possibleValues:[E] = []) {
        name = n
        self.value = value
        self.possibleValues = possibleValues
    }
    
    func getValue() -> E {
        return value
    }
    func setParent(p: Option) {
        parent = p
    }
    
    func add(extraPanel eP: Option) {
        print("not Supported")
    }
    
    func getInfos(at i: Int) -> [String] {
        return [name,"rgerg","fref","ref"]
    }
    
    func getNumberOfRow() -> Int {
        return SettingManagement.amount
    }
    
    func getContent(at i: Int) -> Any? {
        return nil
    }
    func getContent() -> [Any] {
        return []
    }
}

class MenuList: Option {
    
    var mapping:[Buttons:PrimaryActions] = [:]
    
    var type: StateType = StateType.MenuList
    var name: String
    var content: [Option] = []
    var parent: Option?
    var selectedRow: Int = 0
    static let cell: AnyObject = MenuCell()
    
    var extraPanel:Option?
    
    init(name: String) {
        self.name = name
    }
    
    func add(extraPanel eP: Option) {
        extraPanel = eP
        eP.setParent(p: self)
    }
    
    func add(child: Option) {
        content.append(child)
        child.setParent(p: self)
    }
    
    func getInfos(at i: Int) -> [String] {
        return [content[i].name]
    }
    
    func setParent(p: Option) {
        parent = p
    }
    
    func getNumberOfRow() -> Int {
        return content.count
    }
    
    func getContent(at i: Int) -> Any? {
        return content[i]
    }
    
    func getContent() -> [Any] {
        return content
    }
}

class PlayableElementList: Option {
    
    var mapping:[Buttons:PrimaryActions] = [.topRight: .goArtist]
    
    func getContent() -> [Any] {
        return [content]
    }
    
    var type: StateType = StateType.PlayableElementList
    var name: String
    var content: MPMediaItemCollection!
    var parent: Option?
    var extraPanel: Option?
    var selectedRow: Int = 0
    static let cell: AnyObject = SongCell()
    
    init(passedContent: MPMediaItemCollection, n: String) {
        self.content = passedContent
        self.name = n
    }
    
    func add(extraPanel eP: Option) {
        extraPanel = eP
        eP.setParent(p: self)
    }
    
    func setParent(p: Option) {
        parent = p
    }
    
    func getInfos(at i: Int) -> [String] {
        
        if content.items[i].artist == nil {
            return [content.items[i].title!]
        }
        return [content.items[i].title!,content.items[i].artist!]
    }
    
    func getNumberOfRow() -> Int {
        return content.items.count
    }
    
    func getContent(at i: Int) -> Any? {
        return content.items[i]
    }
}

class SettingList: Option {
    
    var mapping:[Buttons:PrimaryActions] = [:]
    
    var extraPanel: Option?
    var selectedRow: Int = 0
    var name: String = "Settings"
    var type: StateType = StateType.SettingList
    var content: [Option] = []
    var parent: Option?
    
    func add(extraPanel eP: Option) {
        print("not Supported")
    }
    
    func setParent(p: Option) {
        parent = p
    }
    
    func getInfos(at i: Int) -> [String] {
        return content[i].getInfos(at: i)
    }
    
    func getNumberOfRow() -> Int {
        return SettingManagement.amount
    }
    
    func getContent(at i: Int) -> Any? {
        return content[i]
    }
    func getContent() -> [Any] {
        return content
    }
    
    func add(child: Option) {
        content.append(child)
        child.setParent(p: self)
    }
}
