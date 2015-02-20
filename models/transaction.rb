class Transaction
  
  def initialize(options)
    @id          = options["id"] 
    @player      = options["player"]
    @source      = options["source"]
    @destination = options["destination"]
    @trade_id    = options["trade_id"]
  end

end