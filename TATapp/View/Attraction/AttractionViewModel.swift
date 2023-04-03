//
//  AttractionViewModel.swift
//  TATapp
//
//  Created by Waleerat Gottlieb on 2023-04-07.
//

import SwiftUI

class AttractionViewModel: ObservableObject {
    
    @Published var mainVM: MainViewModel
    @Published var isLiked: Bool = false
    @Published var isBookMark: Bool = false
    @Published var isCommentSheet: Bool = false
    @Published var isShowMapSheet: Bool = false
    
    @Published var offset: CGFloat = 0
    
    init(mainVM: MainViewModel) {
        self.mainVM = mainVM
    }
    
    func saveLiked(){
        // TODO : - Save to database
        isLiked = !isLiked
        
        print("isLike > \(isLiked)")
    }
    
    func saveBookmark(){
        // TODO : - Save to database
        isBookMark = !isBookMark
    }
    
    func toogleComentIcon(){
        // TODO : - Save to database
        withAnimation(.easeInOut) {
            isCommentSheet = !isCommentSheet
        }
    }
    
    func toggleMapIcon() {
        withAnimation(.easeInOut) {
            isShowMapSheet = !isShowMapSheet
        }
    }
    
    
    func getOffsetType() -> CGFloat {
        if offset > 200{
            let progress = (offset - 200) / 50
            
            if progress <= 1.0{
                return progress * 40
            }
            else{
                return 40
            }
        }
        else{
            return 0
        }
    }
}
