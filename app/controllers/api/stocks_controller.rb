class Api::StocksController < ApplicationController


  def index
    @stocks = Stock.where("symbol iLIKE '#{params[:query]}%'").limit(6)
    # 
    # sql
    # params[:query]
    # @stocks = Stock.all
    render 'api/stocks/index'
  end

  def show
    # @stock = Stock.find(params[:id])
    @stock = Stock.find_by(symbol: params[:symbol].upcase)
    render 'api/stocks/show'
  end


  def stock_params
    params.require(:stock).permit(:symbol)
  end


end
