import UIKit

extension String {
    
    var dateValue: NSDate? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = self.count > 19 ? String(self[..<self.index(self.startIndex, offsetBy: 19)]) : self
        
        return  dateFormatter.date(from:dateString) as NSDate?
    }
}

extension Optional where Wrapped == NSDate {
    
    var longDescription: String? {
        
        guard let date = self as Date? else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
    }
}


let originalDateString = "2018-06-19T06:54:04+00:00"

let formattedDateString = originalDateString.dateValue.longDescription

print(formattedDateString!)


var newArray = [1, 2, 3, 4, 5]
let oldArray = [3, 4, 5, 6, 7]

var toBeAdded: [Int] = []
var commonItems: [Int] = []
var toBeDeleted: [Int] = []

for item in newArray {

    if oldArray.contains(item) {
        commonItems.append(item)
    } else {
        toBeAdded.append(item)
    }
}

toBeDeleted = oldArray.filter {
    !commonItems.contains($0)
}



toBeAdded
commonItems
toBeDeleted



class Oggetto {
    
    let nome: String
    let colore: UIColor
    
    init(nome: String, colore: UIColor) {
        self.nome = nome
        self.colore = colore
    }
}

let oggetti = [ Oggetto(nome: "casa", colore: .red),
                Oggetto(nome: "mia", colore: .green),
                Oggetto(nome: "mia", colore: .green),
                Oggetto(nome: "tua", colore: .red),
                Oggetto(nome: "sua", colore: .blue),
                Oggetto(nome: "nostra", colore: .blue),
                Oggetto(nome: "vostra", colore: .red),
                Oggetto(nome: "loro", colore: .blue),
                Oggetto(nome: "deglialtri", colore: .red),
                Oggetto(nome: "casa", colore: .yellow) ]


let grouped = Dictionary(grouping: oggetti, by: {$0.colore})

var array: [[Oggetto]] = []
for group in grouped {
    array.append(group.value)
}
let sortedArray = array.sorted {$0.count > $1.count}

var quantities = sortedArray.map { $0.count }

quantities.count


var sums: [Int] = []
while quantities.count > 0 {

    sums.append(quantities.reduce(0, +))
    quantities.remove(at: 0)
    print(quantities.count)
}

sums

func date(fromDay day: Int, month: Int, year: Int) -> Date {
    
    var components = DateComponents()
    components.day = 1
    components.month = 2
    components.year = 2016
    return Calendar.current.date(from: components)!
}




let newDate = Calendar.current.date(byAdding: .month, value: 1, to: createdDate)
print(newDate)

extension String {
    
    var dateValue: NSDate? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = self.count > 19 ? String(self[..<self.index(self.startIndex, offsetBy: 19)]) : self
        
        return  dateFormatter.date(from:dateString) as NSDate?
    }
}

extension Optional where Wrapped == NSDate {
    
    var longDescription: String? {
        
        guard let date = self as Date? else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter.string(from: date)
    }
}


let originalDateString = "2018-06-19T06:54:04+00:00"

let formattedDateString = originalDateString.dateValue.longDescription

print(formattedDateString!)
















