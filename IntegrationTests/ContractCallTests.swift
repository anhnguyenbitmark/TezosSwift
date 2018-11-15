//
//  ContractCallTests.swift
//  IntegrationTests
//
//  Created by Marek Fořt on 11/12/18.
//  Copyright © 2018 Keefer Taylor. All rights reserved.
//

import XCTest
@testable import TezosSwift

extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    var hexadecimal: Data? {
        var data = Data(capacity: characters.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}

class ContractCallTests: XCTestCase {

    let tezosClient = TezosClient(remoteNodeURL: Constants.defaultNodeURL)
    var wallet: Wallet!

    override func setUp() {
        let mnemonic = "soccer click number muscle police corn couch bitter gorilla camp camera shove expire praise pill"
        wallet = Wallet(mnemonic: mnemonic)!
    }

    // TODO: Change calling of these calls, so the counter does not conflict
    // These calls have to be executed individually for now
    func testSendingTezos() {
        let testCompletionExpectation = expectation(description: "Sending Tezos")

        tezosClient.send(amount: TezosBalance(balance: 1), to: "KT1UA28DNuXoXNMRjU2HqyrDyCiAmDYnpid9", from: wallet, completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(_):
                testCompletionExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3, handler: nil)
    }


    func testSendingIntParam() {
        let testCompletionExpectation = expectation(description: "Sending Tezos with int param")

        tezosClient.call(address: "KT1UA28DNuXoXNMRjU2HqyrDyCiAmDYnpid9", param1: 10, from: wallet, amount: TezosBalance(balance: 1), completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
                testCompletionExpectation.fulfill()
            case .success(_):
                testCompletionExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testSendingPairParam() {
        let testCompletionExpectation = expectation(description: "Sending Tezos with pair param")
        
        tezosClient.testContract(at: "KT1Rfr8ywXgj4QmGpvoWuJD4XvFMrFhK7D9m").call(param1: true, param2: false).send(from: wallet, amount: TezosBalance(balance: 1), completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
                testCompletionExpectation.fulfill()
            case .success(_):
                testCompletionExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testSendingBytes() {
        let testCompletionExpectation = expectation(description: "Sending Tezos with bytes")
        tezosClient.call(address: "KT1Hbpgho8jUJp6AY2dh1pq61u7b2in1f9DA", param1: "".data(using: .utf8)!, from: wallet, amount: TezosBalance(balance: 1), completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
                testCompletionExpectation.fulfill()
            case .success(_):
                testCompletionExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testPackUnpack() {
        let testCompletionExpectation = expectation(description: "Sending Tezos to PackUnpack contract")

        tezosClient.call(address: "KT1F2aWqKZ8FSmFsTnkUW2wHgNtsRp4nnCEC", param1: "hello", param2: [1, 2], param3: [3, 4], param4: "".data(using: .utf8)!, from: wallet, amount: TezosBalance(balance: 1), completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
                testCompletionExpectation.fulfill()
            case .success(_):
                testCompletionExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3, handler: nil)
    }
}
