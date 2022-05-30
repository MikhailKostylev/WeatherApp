import Foundation

extension String {
    
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
    
    func deletingPrefix() -> String {
        let newString = self.components(separatedBy: "/")
        return newString[1]
    }
}
