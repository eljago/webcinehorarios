ShowFunctionType = GraphQL::ObjectType.define do
  name "ShowFunction"
  description "A Show Function"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :function_id do
  	type types.Int
  	resolve -> (show_function, args, ctx) {
  		show_function.id
  	}
  end
  field :theater_id, types.Int
  field :date, types.String


  field :showtimes do
    type types[types.String]
    
    resolve -> (show_function, args, ctx) {
      show_function.showtimes.map do |showtime|
        I18n.l showtime.time, format: :normal_time
      end
    }
  end

  field :function_types do
    type types[types.String]

    resolve -> (show_function, args, ctx) {
      show_function.function_types.map(&:name)
    }
  end

end