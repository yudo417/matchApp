//
//  AuthViewModel.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/03.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import SwiftUI
import FirebaseStorage

class AuthViewModel: ObservableObject{

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task{
                await self.loadimage()
            }
        }
    }
    @Published var profileImage: UIImage?

    init(){
        self.userSession = Auth.auth().currentUser
        print("ログインユーザー:\(self.userSession?.email)")
//        self.logout()
//        print("\(Auth.auth().currentUser)")
        Task{
            await self.fetchcurrentUser()
        }
    }

    // Login
    @MainActor
    func login(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("ログイン成功:\(result.user.email)")
            self.userSession = result.user
            print("self.userSesstion:\(self.userSession?.email)")
            await self.fetchcurrentUser()
        } catch  {
            print("ログイン失敗:\(error.localizedDescription)")
        }
    }
    // Logout

    func logout(){
        do {
            try Auth.auth().signOut()
            print("ログアウト成功")
            resetAccount()
        } catch  {
            print("ログアウト失敗:\(error.localizedDescription)")
        }
    }

    // Create Account
    @MainActor
    func createAccount(email: String, password: String,name:String ,age: Int)  async {
//
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("ユーザー登録成功:\(result.user.email)")
            self.userSession = result.user

            let newUser = User(id: result.user.uid, name: name, email: email, age: age)

                await uploadUserData(withUser: newUser)

            await self.fetchcurrentUser()

        }catch{
            print("ユーザー登録失敗:\(error.localizedDescription)")
        }
        print("createAccountが呼び出された")
    }
    // Delete Account
    @MainActor
    func deleteAccount() async {

        guard let id = self.currentUser?.id else { return }

        do{
            try await Auth.auth().currentUser?.delete()
            try await Firestore.firestore().collection("users").document(id).delete()
            print("アカウント削除完了")
            resetAccount()
        }catch{
            print("アカウント削除失敗:\(error.localizedDescription)")
        }
    }
    
    private func resetAccount(){
        self.userSession = nil
        self.currentUser = nil
        self.profileImage = nil
    }

    //UPload User Data
    private func uploadUserData(withUser user:User) async {
        do {
            let userData = try Firestore.Encoder().encode(user)//エンコードする
            try await Firestore.firestore().collection("users").document(user.id).setData(userData)
            print("データ保存成功")
        } catch  {
            print("データ保存失敗:\(error.localizedDescription)")
        }

    }
    @MainActor
    private func fetchcurrentUser() async{

        guard let uid = self.userSession?.uid else {return}

        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
            print("カレントユーザー取得成功:\(self.currentUser)")
        } catch  {
            print("カレントユーザー取得失敗:\(error.localizedDescription)")
        }
    }

    func updateUserProfile(withId id: String,name: String,age: Int, message: String)async{

        var data:[AnyHashable:Any]=[
            "name":name,
            "age":age,
            "message":message,
        ]

        if let urlString = await self.uploadImage(){
            data["photoUrl"] = urlString
        }

        do {
            try  await Firestore.firestore().collection("users").document(id).updateData(data)
            print("プロフィール更新成功")
            await self.fetchcurrentUser()
        } catch  {
            print("プロフィール更新失敗:\(error.localizedDescription)")
        }
    }
    // Load image
    @MainActor
    private func loadimage()async{
        guard let image = selectedImage else { return }

        do {
            guard let data = try await image.loadTransferable(type: Data.self) else { return }
            self.profileImage = UIImage(data:data)
        } catch  {
            print("参照失敗:\(error.localizedDescription)")
        }
    }

    // Upload image data
    private func uploadImage()async -> String?{
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/user_images/\(filename)")

        guard let uiImage = self.profileImage else { return nil }
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return nil}


        do {
            let _ = try await storageRef.putDataAsync(imageData)
            print("画像アップ完了")

            let urlString = try await storageRef.downloadURL().absoluteString
            return urlString
        } catch  {
            print("画像アップ失敗:\(error.localizedDescription)")
            return nil
        }
    }

}
