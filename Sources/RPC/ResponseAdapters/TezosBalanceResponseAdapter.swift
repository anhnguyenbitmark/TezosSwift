import Foundation

/**
 * Parse a given response as a string representing a TezosBalance.
 */
public class TezosBalanceAdapter : AbstractResponseAdapter<TezosBalance> {
  public override class func parse(input: Data) -> TezosBalance? {
    guard let balanceString = StringResponseAdapter.parse(input: input) else {
      return nil
    }
    return TezosBalance(balance: balanceString)
  }
}
