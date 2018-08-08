class Trade < ApplicationRecord

  validates :stock_id, :portfolio_id, :price, :size, :trade_type, presence: true


  belongs_to :stock,
    class_name: 'Stock',
    primary_key: :id,
    foreign_key: :stock_id

  belongs_to :portfolio,
    class_name: 'Portfolio',
    primary_key: :id,
    foreign_key: :portfolio_id

  has_one :user,
    through: :portfolio,
    source: :user



  def verify_order
    if self.size <= 0
      errors[:size].push("Cannot trade 0 Stocks")
      return false
    end

    if self.trade_type == "buy"
      return verify_buying_power
    else
      return verify_holdings
    end
  end


  def verify_buying_power
    if (self.price * self.size) <= self.user.buying_power
      return true
    else
      errors[:size].push("Buying power too low")
      return false
    end
  end


  def verify_holdings
    if self.size <= self.portfolio.holdings[self.stock_id]
      return true
    else
      errors[:size].push("Not enough shares")
      return false
    end
  end
end