//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    private let conversions = [
        "GBP": 0.5,
        "EUR": 1.5,
        "CAN": 1.25
    ]
    
    public func convert(to: String) -> Money {
        var mult : Double = 0
        if currency.self == "USD" {
            mult = conversions[to]!
        } else {
            mult = 1 / conversions[currency]!
        }
        let newAmt : Int = Int(Double(amount.self) * mult)
        let ret = Money(amount: newAmt, currency: to)
        
        return ret
    }
  
    public func add(to: Money) -> Money {
        var copy = Money(amount: 0, currency: "USD")
        if currency.self == to.currency {
            copy = self
        } else {
            copy = self.convert(to.currency)
        }
        let newAmt = copy.amount + to.amount
        let ret = Money(amount: newAmt, currency: to.currency)
        return ret
        
    }
    
    public func subtract(from: Money) -> Money {
        var copy = Money(amount: 0, currency: "USD")
        if currency.self == from.currency {
            copy = self
        } else {
            copy = self.convert(from.currency)
        }
        let newAmt = copy.amount - from.amount
        let ret = Money(amount: newAmt, currency: from.currency)
        return ret
    }
    
}



////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    private var title : String
    private var type : JobType
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
  
    public func calculateIncome(hours: Int) -> Int {
        var ret : Double = 0
        switch self.type {
            case .Hourly(let wage): ret = wage * Double(hours)
            case .Salary(let wage): ret = Double(wage)
        }
        return Int(ret)
    }
  
    public func raise(amt : Double) {
        switch self.type {
            case .Hourly(let curr): self.type = .Hourly(amt + curr)
            case .Salary(let curr): self.type = .Salary(Int(amt) + curr)
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    private var half : Person?
    private var profession : Job?

    public var job : Job? {
        get {
            return(profession)
        } set(value) {
            if age >= 16 {
                self.profession = value!
            } else {
                self.profession = nil
            }
        }
    }
  
    public var spouse : Person? {
        get {
            return(half)
        } set(value) {
            if age >= 18 {
                self.half = value!
            } else {
                self.half = nil
            }
        }
    }
  
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
  
    public func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.profession) spouse:\(self.half)]"
    }
}


////////////////////////////////////
// Family
//
public class Family {
    private var members : [Person] = []
  
    public init(spouse1: Person, spouse2: Person) {
        var passed = false
        if spouse1.spouse == nil && spouse2.spouse == nil {
            passed = true
        }
        if passed {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
        
    }
  
    public func haveChild(child: Person) -> Bool {
        var over21 = false
        for i in 0 ... members.count - 1 {
            if members[i].age >= 20 {
                over21 = true
            }
        }
        if over21 {
            members.append(child)
            return true
        }
        return false
    }
  
    public func householdIncome() -> Int {
        //using 5 hours as a placeholder because idk how many hours / year people are working
        var total = 0
        for index in 0 ... members.count - 1 {
            let person = members[index]
            if person.job != nil {
                total = total + person.job!.calculateIncome(2000)
            }
            
        }
        return total
    }
}


