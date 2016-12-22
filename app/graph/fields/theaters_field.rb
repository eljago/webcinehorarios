TheatersField = GraphQL::Field.define do
  name('theaters')
  
  argument :cacheTime, types.String
  argument :cinema_id, types.Int, default_value: nil
  
  type types[TheaterType]

  # Custom resolver
  resolve(TheatersResolver.new)
end