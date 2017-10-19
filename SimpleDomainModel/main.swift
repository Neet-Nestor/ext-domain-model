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

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Protocols
//
protocol CustomStringConvertible {
    var description: String { get }
}

protocol Mathematics {
    func add(_ to:Self) -> Self
    func subtract(_ from:Self) -> Self
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : CurrencyType
    public var description: String {
        get {
            return "\(self.currency)\(self.amount)"
        }
    }
    
    public enum CurrencyType {
        case USD
        case EUR
        case CAN
        case GBP
    }
    
    init(amount: Int, currency: CurrencyType) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ to: CurrencyType) -> Money {
        var resultAmount: Int = 0
        switch self.currency {
        case .USD:
            switch to {
            case .EUR:
                resultAmount = Int(1.5 * Double(self.amount))
            case .CAN:
                resultAmount = Int(1.25 * Double(self.amount))
            case .GBP:
                resultAmount = Int(0.5 * Double(self.amount))
            case .USD:
                resultAmount = self.amount
            }
        case .EUR:
            switch to {
            case .USD:
                resultAmount = 2 * self.amount / 3
            case .CAN:
                resultAmount = Int(Double(2 * self.amount / 3) * 1.25)
            case .GBP:
                resultAmount = self.amount / 3
            case .EUR:
                resultAmount = self.amount
            }
        case .CAN:
            switch to {
            case .USD:
                resultAmount = 4 * self.amount / 5
            case .EUR:
                resultAmount = 6 * self.amount / 5
            case .GBP:
                resultAmount = 2 * self.amount / 5
            case .CAN:
                resultAmount = self.amount
            }
        case .GBP:
            switch to {
            case .EUR:
                resultAmount = 3 * self.amount
            case .CAN:
                resultAmount = Int(2.5 * Double(self.amount))
            case .USD:
                resultAmount = self.amount * 2
            case .GBP:
                resultAmount = self.amount
            }
            
        }
        return Money(amount: resultAmount, currency: to)
    }
    
    public func add(_ to: Money) -> Money {
        if (to.currency == self.currency) {
            return Money(amount: (self.amount + to.amount), currency: self.currency)
        } else {
            return Money(amount: (self.convert(to.currency).amount + to.amount), currency: to.currency)
        }
    }

  public func subtract(_ from: Money) -> Money {
    return Money(amount: from.amount - self.amount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//

open class Job: CustomStringConvertible {
    fileprivate var title : String
    fileprivate var type : JobType

    public var description: String {
        get {
            switch type {
            case .Hourly(let hourlySalary):
                return "Job: \(self.title) Salary(Hourly): \(hourlySalary)"
            case .Salary(let yearSalary):
                return "Job: \(self.title) Salary(Year): \(yearSalary)"
            }
        }
    }

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hourlySalary):
        return Int(hourlySalary * Double(hours))
    case .Salary(let yearSalary):    // case .Salary
        return yearSalary
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hourlySalary):
        self.type = JobType.Hourly(hourlySalary + amt)
    case .Salary(let yearlySalary):
        self.type = JobType.Salary(Int(amt) + yearlySalary)
    }
  }
    
    open func raise(_ amt: Int) {
        raise(Double(amt))
    }
}

//////////////////////////////////// // Person
//

open class Person: CustomStringConvertible {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    open var description: String {
        get {
            return toString()
        }
    }

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        if (self.age >= 16) {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if (self.age >= 18) {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    var jobString = "nil"
    var spouseString = "nil"
    if (self.job != nil) {
        jobString = self.job!.title
    }
    if (self.spouse != nil) {
        spouseString = self.spouse!.firstName + " " + self.spouse!.lastName
    }
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(jobString) spouse:\(spouseString)]"
  }
}

////////////////////////////////////
// Family
//
open class Family: CustomStringConvertible {
  fileprivate var members : [Person] = []
    public var description: String {
        get {
            var membersString: String = ""
            for member in members {
                membersString = membersString + member.description + "\n"
            }
            return membersString
        }
    }
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    child.age = 0
    members.append(child)
    return true
  }
  open func householdIncome() -> Int {
    var sumIncome: Int = 0
    for individual in members {
        if (individual.job != nil) {
            switch individual.job!.type {
            case .Hourly(let hourlySalary):
                sumIncome += Int(hourlySalary * 2000)
            case .Salary(let yearlySalary):
                sumIncome += yearlySalary
            }
        }
    }
    return sumIncome
  }
}

////////////////////////////////////
// Extention
//
extension Double {
    var EUR:Money {
        return Money(amount: Int(self), currency: Money.CurrencyType.EUR)
    }
    var USD:Money {
        return Money(amount: Int(self), currency: Money.CurrencyType.USD)
    }
    var CAN:Money {
        return Money(amount: Int(self), currency: Money.CurrencyType.CAN)
    }
    var GBP:Money {
        return Money(amount: Int(self), currency: Money.CurrencyType.GBP)
    }
}
