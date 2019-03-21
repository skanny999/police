import UIKit

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






