//
//  DataTest.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import Foundation

struct DataTest: Identifiable {
    var id = UUID().uuidString
    var idKey: Int
    var text: String
}

var phrases = [
    DataTest(idKey: 1, text: "Non aver paura, perche' sono qui per proteggerti"),
    DataTest(idKey: 2, text: "Credo in te e nella tua forza"),
    DataTest(idKey: 3, text: "Ti meriti tutta la felicita' e la pace del mondo"),
    DataTest(idKey: 4, text: "Fai un passo alla volta e abbi fede di essere sulla strada giusta"),
    DataTest(idKey: 5, text: "Trai conforto nella consapevolezza che tutte le cose passano, sia buone che cattive"),
    DataTest(idKey: 6, text: "Prenditi del tempo per riflettere e apprezzare tutto il bene della tua vita"),
    DataTest(idKey: 7, text: "Sei in grado di superare qualsiasi sfida, abbi solo fede e fiducia in te stesso"),
    DataTest(idKey: 8, text: "Il mondo e' un posto bellissimo, tieni gli occhi aperti per le sue meraviglie"),
    DataTest(idKey: 9, text: "Non aver paura di chiedere perdono, e' un potente atto di guarigione"),
    DataTest(idKey: 10, text: "Non arrenderti, hai il potere di superare qualsiasi ostacolo"),
    DataTest(idKey: 11, text: "Sii gentile con te stesso, sei in un continuo processo di crescita e miglioramento"),
    DataTest(idKey: 12, text: "Sei una fonte di ispirazione, non smettere mai di far brillare la tua luce."),
    DataTest(idKey: 13, text: "Perdona te stesso e vai avanti, portera' la pace")
]
