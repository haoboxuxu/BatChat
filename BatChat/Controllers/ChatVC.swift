//
//  ChatVC.swift
//  BatChat
//
//  Created by 徐浩博 on 2021/11/1.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatVC: MessagesViewController {
    
    private var messages: [Message] = []
    private var selfSender = Sender(photoURL: "", senderId: "1", displayName: "haoboxuxu")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Who are you?")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("❤️?")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("🍆")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}

extension ChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
