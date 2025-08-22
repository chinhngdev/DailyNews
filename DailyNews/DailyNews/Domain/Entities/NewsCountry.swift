//
//  NewsCountry.swift
//  DailyNews
//
//  Created by Chinh on 8/22/25.
//

import Foundation

enum NewsCountry: String, CaseIterable {
    case unitedArabEmirates = "ae"
    case argentina = "ar"
    case austria = "at"
    case australia = "au"
    case belgium = "be"
    case bulgaria = "bg"
    case brazil = "br"
    case canada = "ca"
    case switzerland = "ch"
    case china = "cn"
    case colombia = "co"
    case cuba = "cu"
    case czechRepublic = "cz"
    case germany = "de"
    case egypt = "eg"
    case france = "fr"
    case unitedKingdom = "gb"
    case greece = "gr"
    case hongKong = "hk"
    case hungary = "hu"
    case indonesia = "id"
    case ireland = "ie"
    case israel = "il"
    case india = "in"
    case italy = "it"
    case japan = "jp"
    case southKorea = "kr"
    case lithuania = "lt"
    case latvia = "lv"
    case morocco = "ma"
    case mexico = "mx"
    case malaysia = "my"
    case nigeria = "ng"
    case netherlands = "nl"
    case norway = "no"
    case newZealand = "nz"
    case philippines = "ph"
    case poland = "pl"
    case portugal = "pt"
    case romania = "ro"
    case serbia = "rs"
    case russia = "ru"
    case saudiArabia = "sa"
    case sweden = "se"
    case singapore = "sg"
    case slovenia = "si"
    case slovakia = "sk"
    case thailand = "th"
    case turkey = "tr"
    case taiwan = "tw"
    case ukraine = "ua"
    case unitedStates = "us"
    case venezuela = "ve"
    case southAfrica = "za"
    
    var displayName: String {
        switch self {
        case .unitedArabEmirates: L10n.countryUnitedArabEmirates
        case .argentina: L10n.countryArgentina
        case .austria: L10n.countryAustria
        case .australia: L10n.countryAustralia
        case .belgium: L10n.countryBelgium
        case .bulgaria: L10n.countryBulgaria
        case .brazil: L10n.countryBrazil
        case .canada: L10n.countryCanada
        case .switzerland: L10n.countrySwitzerland
        case .china: L10n.countryChina
        case .colombia: L10n.countryColombia
        case .cuba: L10n.countryCuba
        case .czechRepublic: L10n.countryCzechRepublic
        case .germany: L10n.countryGermany
        case .egypt: L10n.countryEgypt
        case .france: L10n.countryFrance
        case .unitedKingdom: L10n.countryUnitedKingdom
        case .greece: L10n.countryGreece
        case .hongKong: L10n.countryHongKong
        case .hungary: L10n.countryHungary
        case .indonesia: L10n.countryIndonesia
        case .ireland: L10n.countryIreland
        case .israel: L10n.countryIsrael
        case .india: L10n.countryIndia
        case .italy: L10n.countryItaly
        case .japan: L10n.countryJapan
        case .southKorea: L10n.countrySouthKorea
        case .lithuania: L10n.countryLithuania
        case .latvia: L10n.countryLatvia
        case .morocco: L10n.countryMorocco
        case .mexico: L10n.countryMexico
        case .malaysia: L10n.countryMalaysia
        case .nigeria: L10n.countryNigeria
        case .netherlands: L10n.countryNetherlands
        case .norway: L10n.countryNorway
        case .newZealand: L10n.countryNewZealand
        case .philippines: L10n.countryPhilippines
        case .poland: L10n.countryPoland
        case .portugal: L10n.countryPortugal
        case .romania: L10n.countryRomania
        case .serbia: L10n.countrySerbia
        case .russia: L10n.countryRussia
        case .saudiArabia: L10n.countrySaudiArabia
        case .sweden: L10n.countrySweden
        case .singapore: L10n.countrySingapore
        case .slovenia: L10n.countrySlovenia
        case .slovakia: L10n.countrySlovakia
        case .thailand: L10n.countryThailand
        case .turkey: L10n.countryTurkey
        case .taiwan: L10n.countryTaiwan
        case .ukraine: L10n.countryUkraine
        case .unitedStates: L10n.countryUnitedStates
        case .venezuela: L10n.countryVenezuela
        case .southAfrica: L10n.countrySouthAfrica
        }
    }
}
