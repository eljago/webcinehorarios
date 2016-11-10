class QlFunctionsResolver
  def call(_, args, _)
    Function.where(theater_id: args[:theater_id], date: args[:date])
  end
end
