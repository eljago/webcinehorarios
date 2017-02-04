TheatersField = GraphQL::Field.define do
  name('theaters')

  argument :cacheTime, types.String
  argument :cinema_id, types.Int, default_value: nil
  argument :theater_ids, types.String, default_value: nil

  argument :show_id, types.Int

  type types[TheaterType]

  # Custom resolver
  resolve(TheatersResolver.new)
end
