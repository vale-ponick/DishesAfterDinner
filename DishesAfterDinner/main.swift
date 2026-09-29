//
//  main.swift
//  DishesAfterDinner
//
//  Created by Валерия Пономарева on 25.09.2026.
//

import Foundation

// MARK: - 📋 ТЗ: 'Dishes after Dinner' - A hostess is about to wash the dishes after a dinner with guests, using both the dishwasher and by hand. Write a function that: Accepts an array of dishes, cycles through them, and sorts them according to washing method: If fragile - crystal, porcelain, and gold plated → "Careful, hand only"; If spoons, forks, and knives → "Normal mode - dishwasher"; If pots and pans → "Intensive mode - dishwasher"; If something unknown is encountered → "Unknown dishes."

// 1. Data
// 1. Dishes — enum
enum Dish { case crystal, porcelain, goldPlated, cutlery, potsAndPans }

enum WashingMethod {
    case byHand
    case diswasherNormal
    case diswasherIntensive
    case unknown
    
    var name: String {
        switch self {
        case .byHand:               return "Careful, hand only"
        case .diswasherNormal:      return "Normal mode - dishwasher"
        case .diswasherIntensive:   return "Intensive mode - dishwasher"
        case .unknown:              return "Unknown dishes"   // ← с большой буквы
        }
    }
}

// Исправленная и более аккуратная функция уровня Beginner
func sort(_ dishes: [Dish]) { // Убрали лишний параметр
    for dish in dishes {
        // Современный Swift-выражение switch по строке
        let method: WashingMethod = switch dish {
        case .crystal, .porcelain, .goldPlated:
            .byHand
        case .cutlery:
            .diswasherNormal
        case .potsAndPans:
            .diswasherIntensive
        }
        print("For \(dish) - \(method.name).")
    }
}

// Добавим "unknown" для честной проверки
let testDishes: [Dish] = [.crystal, .cutlery, .potsAndPans]
sort(testDishes) // For crystal - washing method: Careful, hand only. For spoons, forks and knives - washing method: Normal mode - dishwasher. For alien spaceship - washing method: Unknown dishes. For pots and pans - washing method: Intensive mode - dishwasher.

// MARK:  - Задача: «Светофор» 🚦У вас есть строковая переменная let trafficLight = "red" (значения могут быть "red", "yellow", "green" или вообще любой случайный текст).Задание: Напишите современный switch, который определяет действие водителя (let action: String) и возвращает:для "red" -> "Stop"для "yellow" -> "Ready"для "green" -> "Go"для всего остального -> "Broken traffic light".

let trafficLight = "red"

let action: String = switch trafficLight {
case "red": "Stop" // Stop
case "yellow": "Ready"
case "green": "Go"
default: "Broken traffic light"
}
print(action) // Stop

// MARK: - Задача («Размер одежды»). Дано: let size = 46. Создай let internationalSize: String через современный switch.

let size = 54

let internationalSize: String = switch size {
case 42...44: "S"
case 46...48: "M"
case 50...52: "L"
case 54...: "XL"
default: "Unknown size"
}
print(internationalSize) // XL

// MARK: - 'Coffee vending machine'.
// ⚙️ ИНЖЕНЕРНАЯ РЕФЛЕКСИЯ: БАТТЛ ПАТТЕРНОВ

// вар. 1 🧰 : IIFE  - 'Немедленно вызываемое замыкание' NB: нарушает принцип единой ответственности (Single Responsibility).  switch должен просто сопоставлять данные, а не крутить внутри себя анонимные микро-функции с побочными эффектами (принтами).
let order = "latte"

let price: Int = switch order {
case "latte":
    { print("🥛☕ Add some of milk..."); return 200 }()
case "espresso":
    100
default:
    0
}

print(price) // 🥛 Add some of milk... 200

// var.2 🔀 Вариант 2: 'Вынос принта в if за пределы switch' очень часто используется в реальной разработке, когда нужно сохранить лаконичность кода. NB: главная уязвимость — рассинхронизация 'fragility' приходится дважды проверять одну и ту же строку: сначала внутри switch, а потом ниже в условии if =>  классический источник багов (Side Effects).
let cap = "cappuccino"
let priceCoffee = switch cap {
case "cappuccino": 150
case "espresso":   100
default:           0
}
if cap == "cappuccino" { print("☕♨️ Мilk froths...") } // ☕ ♨️ Мilk froths...

// var. 3 🛠️ Функция рулит! - самый чистый стандарт для продакшена ?? он реализует инкапсуляцию -> выделение логики в функцию =>  невозможно сломать внешними манипуляциями + невероятно легко тестировать NB: print внутри функции - not best practice => функция должна только возвращать цену, а не печатать.
let cupOfCoffee = "espresso"

func getPrice(for beverage: String) -> Int {
    switch beverage {
    case "cappuccino":
        print("☕💨 Milk froths...") // Промежуточное действие
        return 150                        // Финальный возврат цены
    case "espresso":
        print("☕ only black coffee...")
        return 100                        // Однострочный кейс
    default:
        return 0
    }
}

let priceCupOfCoffee = getPrice(for: cupOfCoffee)
print(priceCupOfCoffee) // ☕ only black coffee... 100

// var. 4 PRO -> enum Beverage вместо строк +  Разделение ответственности == production
enum Coffee {
    case cappuccino, espresso, latte, americano
}

func price(for cup: Coffee) -> Int {
    switch cup {
    case .cappuccino: return 150
    case .espresso:   return 100
    case .americano: return 80
    case .latte: return 120
    }
}

func prepare(_ cup: Coffee) {
    switch cup {
    case .cappuccino: print("☕💨 Milk froths...")
    case .espresso:   print("☕ Only black coffee...")
    case .americano: print("☀️☕ Best for morning!")
    case .latte: print("🥛☕ Add some of milk...")
    }
}

let cup = Coffee.americano
prepare(cup)
print(price(for: cup)) // ☀️☕ Best for morning! 80


// var. 5 PRO 'Coffee vending machine': final decision => enum + computed properties + CustomStringConvertible

enum Cup: CustomStringConvertible, CaseIterable {
    case cappuccino, espresso, latte, americano
    
    var price: Int {
        switch self {
        case .cappuccino: 150
        case .espresso: 100
        case .latte: 200
        case .americano: 80
        }
    }
    
    var description: String {
        switch self {
        case .cappuccino: "☕💨 Milk froths..."
        case .espresso: "☕ Only black coffee..."
        case .americano: "☀️☕♨️ Best for morning!"
        case .latte: "🥛☕ Add some of milk..."
        }
    }
}

let myCup = Cup.americano
print(myCup) // ☀️☕♨️ Best for morning!
print(myCup.price) // 80

for cup in Cup.allCases {
    print("\(cup): \(cup.price)")
    /*
    ☕💨 Milk froths...: 150
    ☕ Only black coffee...: 100
    🥛☕ Add some of milk...: 200
    ☀️☕♨️ Best for morning!: 80 */
}

/*
 
 🏆 ИТОГИ КОФЕЙНОГО МАРАФОНА (Связка 1️⃣ + 3️⃣ + 5️⃣):
 1. Инкапсуляция PRO: Перечисление больше не просто список строк, это умный объект.
 2. Системные контракты: CustomStringConvertible избавил от кастомных свойств.
 3. Swift 6.4 Ready: Однострочные switch внутри свойств работают без лишних слов.
 4. Связка инкапсуляции (1) + чистых функций (3) + computed properties (5) — это и есть продакшен-паттерн.
*/

