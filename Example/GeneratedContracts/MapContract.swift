// Generated using TezosGen
// swiftlint:disable file_length

import Foundation
import TezosSwift

/// Struct for function currying
struct MapContractBox {
    fileprivate let tezosClient: TezosClient
    fileprivate let at: String

    fileprivate init(tezosClient: TezosClient, at: String) {
       self.tezosClient = tezosClient
       self.at = at
    }
    /**
     Call MapContract with specified params.
     **Important:**
     Params are in the order of how they are specified in the Tezos structure tree
    */
    func call(_ param1: [Int: Int]) -> ContractMethodInvocation {
        let send: (_ from: Wallet, _ amount: TezToken, _ operationFees: OperationFees?, _ completion: @escaping RPCCompletion<String>) -> Cancelable?
        let input: TezosMap<Int, Int> = TezosMap(pairs: param1.map { TezosPair(first: $0.0, second: $0.1) })
        send = { from, amount, operationFees, completion in
            self.tezosClient.send(amount: amount, to: self.at, from: from, input: input, operationFees: operationFees, completion: completion)
        }

        return ContractMethodInvocation(send: send)
    }

    /// Call this method to obtain contract status data
    @discardableResult
    func status(completion: @escaping RPCCompletion<MapContractStatus>) -> Cancelable? {
        let endpoint = "/chains/main/blocks/head/context/contracts/" + at
        return tezosClient.sendRPC(endpoint: endpoint, method: .get, completion: completion)
    }
}

/// Status data of MapContract
struct MapContractStatus: Decodable {
    /// Balance of MapContract in Tezos
    let balance: Tez
    /// Is contract spendable
    let spendable: Bool
    /// MapContract's manager address
    let manager: String
    /// MapContract's delegate
    let delegate: StatusDelegate
    /// MapContract's current operation counter
    let counter: Int
    /// MapContract's storage
    let storage: [Int: Int]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContractStatusKeys.self)
        self.balance = try container.decode(Tez.self, forKey: .balance)
        self.spendable = try container.decode(Bool.self, forKey: .spendable)
        self.manager = try container.decode(String.self, forKey: .manager)
        self.delegate = try container.decode(StatusDelegate.self, forKey: .delegate)
        self.counter = try container.decodeRPC(Int.self, forKey: .counter)

        let scriptContainer = try container.nestedContainer(keyedBy: ContractStatusKeys.self, forKey: .script)
        self.storage = try scriptContainer.decode(TezosMap<Int, Int>.self, forKey: .storage).pairs.reduce([:], { var mutable = $0; mutable[$1.first] = $1.second; return mutable })
    }
}

extension TezosClient {
    /**
     This function returns type that you can then use to call MapContract specified by address.

     - Parameter at: String description of desired address.

     - Returns: Callable type to send Tezos with.
    */
    func mapContract(at: String) -> MapContractBox {
        return MapContractBox(tezosClient: self, at: at)
    }
}