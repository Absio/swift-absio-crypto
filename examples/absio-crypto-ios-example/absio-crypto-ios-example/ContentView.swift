//
//  ContentView.swift
//  absio-crypto-ios-example
//
//  Copyright © 2020 Absio. All rights reserved.
//

import SwiftUI
import AbsioCryptoiOS

struct ContentView: View {
    private let testTextData = "Some test data"
    
    private var alice_pkey: IndexedECPrivateKey?
    private var bob_pkey: IndexedECPrivateKey?
    
    @State private var encryptedData: Data? = nil
    @State private var decryptedData: String? = nil
    
    @State private var aliceId: UUID? = nil
    @State private var objectId: UUID? = nil
    
    @State private var decryptedAliceId: UUID? = nil
    @State private var decryptedObjectId: UUID? = nil
    
    @State private var error: String = ""
    
    init() {
        let eccHelper = ECCHelper()
        self.alice_pkey = try? eccHelper.generateIndexedPrivateKey(index: 1)
        self.bob_pkey = try? eccHelper.generateIndexedPrivateKey(index: 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .center, spacing: 50) {
                Text("AbsioIES example")
                    .fontWeight(.bold)
                    .font(.title)
                
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                HStack (alignment: .center, spacing: 40){
                    Button(action:{
                        do {
                            try self.enctypt()}
                        catch {}
                    }) {
                        HStack {
                            Text("Encrypt")
                                .fontWeight(.light)
                                .font(.headline)
                        }
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                    Button(action:{
                        self.dectypt()
                    }) {
                        HStack {
                            Text("Dectypt")
                                .fontWeight(.light)
                                .font(.headline)
                        }
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    Button(action:{
                        self.cleanStateData()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .font(.headline)
                            Text("Reset")
                                .fontWeight(.light)
                                .font(.headline)
                        }
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                }
                
            } .frame(minWidth: 0, maxWidth: .infinity)
            
            Divider()
            
            HStack(alignment: .center, spacing: 20){
                Text("Raw data to enctypt: ")
                    .fontWeight(.heavy)
                    .font(.callout)
                Text("\"\(testTextData)\"")
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Enctypted user and object ids: ")
                    .fontWeight(.heavy)
                    .font(.callout)
                HStack(alignment: .center, spacing: 5) {
                    Text("Alice Id:")
                        .fontWeight(.medium)
                        .font(.callout)
                    
                    Text("\(self.aliceId?.uuidString ?? "" )")
                        .fontWeight(.medium)
                        .font(.caption)
                    
                }
                HStack(alignment: .center, spacing: 5) {
                    Text("Object Id:")
                        .fontWeight(.medium)
                        .font(.callout)
                    
                    Text("\(self.objectId?.uuidString ?? "" )")
                        .fontWeight(.medium)
                        .font(.caption)
                }
            } .padding(.horizontal, 10)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Decrypted data from schema:")
                    .fontWeight(.heavy)
                    .font(.callout)
                
                HStack {
                    Text("Alice Id:")
                        .fontWeight(.medium)
                        .font(.callout)
                    Text("\(self.decryptedAliceId?.uuidString ?? "" )")
                        .fontWeight(.medium)
                        .font(.caption)
                }
                
                HStack{
                    Text("Object Id:")
                        .fontWeight(.medium)
                        .font(.callout)
                    Text("\(self.decryptedObjectId?.uuidString ?? "" )")
                        .fontWeight(.medium)
                        .font(.caption)
                }
                HStack {
                    Text("Decrypted data: ")
                        .fontWeight(.medium)
                        .font(.callout)
                    Text("\(self.decryptedData ?? "" )")
                        .fontWeight(.medium)
                        .font(.caption)
                }
            } .padding(.horizontal, 10)
        
            HStack(alignment: .center) {
                Text("\(self.error)")
                .fontWeight(.bold)
                .font(.callout)
                .foregroundColor(Color.red)
                .fixedSize(horizontal: false, vertical: true)
            }.padding(10)
        }
    }
    
    private func cleanStateData() {
        self.decryptedData = nil
        self.encryptedData = nil
        
        self.aliceId = nil
        self.decryptedAliceId = nil
        
        self.objectId = nil
        self.decryptedObjectId = nil
        
        self.error = ""
    }
    
    private func enctypt() throws {
        cleanStateData()
        
        self.aliceId = UUID.init()
        self.objectId = UUID.init()
        
        let eccHelper = ECCHelper()
        let testData = self.testTextData.toData()
        
        self.encryptedData = try eccHelper.absioIESEncrypt(data: testData, signingPrivateKey: self.alice_pkey!, derivationPublicKey: self.bob_pkey!.getIndexedECPublicKey(), userId: self.aliceId!, objectId: self.objectId!)
    }
    
    private func isDataAvailableForDecryption() -> Bool {
        return self.alice_pkey != nil
            && self.bob_pkey != nil
            && self.encryptedData != nil
            && self.aliceId != nil
            && self.objectId != nil
    }
    
    private func dectypt() {
        guard isDataAvailableForDecryption() else {
            self.error = "Nothing to decrypt, please press encrypt botton first"
            return
        }
        
        
        let eccHelper = ECCHelper()
        
        let parsedStruct = AbsioIESStruct.parse(data: self.encryptedData!)
        
        self.decryptedAliceId = parsedStruct.userId
        self.decryptedObjectId = parsedStruct.objectId
        
        let decrypted = try? eccHelper.absioIESDecrypt(absioIESData: self.encryptedData!, signingPublicKey: alice_pkey!.getIndexedECPublicKey().ecKey, derivationPrivateKey: bob_pkey!.ecKey)
        
        self.decryptedData = String(decoding: decrypted!, as: UTF8.self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
