//
//  RidersConnectSlice.swift
//  moto-front
//
//  Created by Алексей on 07.11.2025.
//

import SwiftUI
import Combine
import Apollo
import MotoApi

struct User: Identifiable, Equatable {
    let id = UUID()
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class RidersConnectSlice: ObservableObject {
    @Published var contacts: [User] = []
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    
    
    
    func fetchContacts(search: String?) {
        Task {
            self.isLoading = true
    //        let response = try await apollo.fetch(query: Query)
            let input = GetMyContactInput(searchField: .some(search ?? ""))
            let getContactQuery = GetContactQuery(search: input)
            let result = try await NetworkManager.shared.apollo.fetch(query: getContactQuery)
            
            print("Количество контактов: \((result.data?.getContact.count) ?? 0)")
//            self.users = result.data?.getContact ?? []
            let allContacts = result.data?.getContact ?? []
          
            self.contacts = allContacts
                  .filter { $0.isMyContact }
                  .map { contact in
                      User(name: contact.name)
                  }
              
              self.users = allContacts
                  .filter { !$0.isMyContact }
                  .map { contact in
                      User(name: contact.name)
                  }
            self.isLoading = false
        }
    }
    
    init() {
       fetchContacts(search: "")
    }
}

//struct RidersConnectSlice: ObservableObject {
//@Published var user: UserData[] = []
//    
//    func onInit() {
//        
//    }
//    
//}
