import Foundation

/**
 * A model of a wallet in the Tezos ecosystem.
 *
 * Clients can create a new wallet by calling the empty initializer. Clients can also restore an
 * existing wallet by providing an mnemonic and optional passphrase.
 */
public struct Wallet {
	/** Keys for the wallet. */
	public let keys: Keys

	/**
     A base58check encoded public key hash for the wallet, prefixed with "tz1" which represents an
     address in the Tezos ecosystem.
     */
	public let address: String

	/**
     If this wallet was gnerated from a mnemonic, a space delimited string of english mnemonic words
     used to generate the wallet with the BIP39 specification, otherwise nil.
     */
	public let mnemonic: String?


	/**
     Create a wallet with a given secret key.

     - Parameter secretKey: A base58check encoded secret key, prefixed with "edsk".
   */
	public init?(secretKey: String) {
		guard let publicKey = Crypto.extractPublicKey(secretKey: secretKey),
			let address = Crypto.extractPublicKeyHash(secretKey: secretKey) else {
				return nil
		}
		self.init(publicKey: publicKey, secretKey: secretKey, address: address, mnemonic: nil)
	}

	/** Private initializer to create the wallet with the given inputs. */
	private init(publicKey: String, secretKey: String, address: String, mnemonic: String?) {
		self.keys = Keys(publicKey: publicKey, secretKey: secretKey)
		self.address = address
		self.mnemonic = mnemonic
	}
}

extension Wallet: Equatable {
  public static func == (lhs: Wallet, rhs: Wallet) -> Bool {
    return lhs.address == rhs.address && lhs.keys.secretKey == rhs.keys.secretKey
  }
}
