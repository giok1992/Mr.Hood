# == Schema Information
#
# Table name: portfolios
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Portfolio < ApplicationRecord

  validates :user_id, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

  has_many :portfolio_snapshots,
    primary_key: :id,
    foreign_key: :portfolio_id,
    class_name: 'PortfolioSnapshot'

  has_many :trades,
    primary_key: :id,
    foreign_key: :portfolio_id,
    class_name: 'Trade'

  has_many :stocks,
    through: :trades,
    source: :stock

  after_create :create_snapshot


  def holdings
    # holdings = {}
    holdings = Hash.new(0)

    self.trades.each do |trade|
      if trade.trade_type == "buy"
        holdings[trade.stock.symbol] += trade.size
      else
        holdings[trade.stock.symbol] -= trade.size
      end
    end
    holdings.delete_if { | stock, size | size == 0 }

    holdings
  end

  def value
    value = 0

    self.trades.each do |trade|
      #
      # trade = Trade.find_by(stock_id: key)
      value += trade.price * trade.size
    end

    value
  end

  def create_snapshot
    PortfolioSnapshot.create(
      portfolio_id: self.id,
      value: self.user.buying_power + self.value,
      date: Date.today.to_s
    )
  end
end
