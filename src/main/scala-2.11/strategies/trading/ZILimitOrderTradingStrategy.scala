package strategies.trading

import akka.agent.Agent

import actors.RandomTraderConfig
import markets.tickers.Tick
import markets.tradables.Tradable

import scala.collection.mutable
import scala.util.Random


/** Zero Intelligence (ZI) limit order trading strategy from Gode and Sunder, JPE (1996). */
class ZILimitOrderTradingStrategy(val config: RandomTraderConfig, val prng: Random)
  extends RandomLimitOrderTradingStrategy {

  def askPrice(ticker: Agent[Tick], tradable: Tradable): Long = {
    uniformRandomVariate(config.minAskPrice, config.maxAskPrice)
  }

  def askQuantity(ticker: Agent[Tick], tradable: Tradable): Long = {
    uniformRandomVariate(config.minAskQuantity, config.maxAskQuantity)
  }

  def bidPrice(ticker: Agent[Tick], tradable: Tradable): Long = {
    uniformRandomVariate(config.minBidPrice, config.maxBidPrice)
  }

  def bidQuantity(ticker: Agent[Tick], tradable: Tradable): Long = {
    uniformRandomVariate(config.minBidQuantity, config.maxBidQuantity)
  }

  def chooseOneOf(tickers: mutable.Map[Tradable, Agent[Tick]]): Option[(Tradable, Agent[Tick])] = {
    if (tickers.isEmpty) None else Some(tickers.toIndexedSeq(prng.nextInt(tickers.size)))
  }

  protected def uniformRandomVariate(lower: Long, upper: Long): Long = {
    (lower + (upper - lower) * prng.nextDouble()).toLong
  }

}


object ZILimitOrderTradingStrategy {

  def apply(config: RandomTraderConfig, prng: Random): ZILimitOrderTradingStrategy = {
    new ZILimitOrderTradingStrategy(config, prng)
  }

}