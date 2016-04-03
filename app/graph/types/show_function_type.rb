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
  field :theater_id, types.Int, "Theater id"
  field :date, types.String, "Show Function date"


  field :showtimes do
    type types.String
    resolve -> (show_function, args, ctx) {
      show_function.showtimes.order(:time).map do |showtime|
        I18n.l showtime.time, format: :normal_time
      end.join(", ")
    }
  end

  field :function_types do
    type types.String
    resolve -> (show_function, args, ctx) {
      show_function.function_types.order(:name).map(&:name).join(', ')
    }
  end

  field :show, ShowType
end