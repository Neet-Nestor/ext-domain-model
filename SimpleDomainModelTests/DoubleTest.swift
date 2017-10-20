//
//  DoubleTest.swift
//  SimpleDomainModelTests
//
//  Created by Student User on 10/19/17.
//  Copyright © 2017 Ted Neward. All rights reserved.
//

import XCTest

import SimpleDomainModel

class DoubleTest: XCTestCase {
    let tenUSD = 10.0.USD
    let fifteenGBP = 15.0.GBP
    let fiveCAN = 5.0.CAN
    let nineteenEUR = 19.0.EUR
    
    func testTenUSD() {
        XCTAssert(tenUSD.amount == 10)
        XCTAssert(tenUSD.currency == Money.CurrencyType.USD)
    }
    
    func testFifteenGBP() {
        XCTAssert(fifteenGBP.amount == 15)
        XCTAssert(fifteenGBP.currency == Money.CurrencyType.GBP)
    }
    
    func testFiveCAN() {
        XCTAssert(fiveCAN.amount == 5)
        XCTAssert(fiveCAN.currency == Money.CurrencyType.CAN)
    }
    
    func testNineteenEUR() {
        XCTAssert(nineteenEUR.amount == 19)
        XCTAssert(nineteenEUR.currency == Money.CurrencyType.EUR)
    }
}
