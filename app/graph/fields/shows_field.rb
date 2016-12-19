ShowsField = GraphQL::Field.define do
  name('shows')

  argument :cacheTime, types.String
  argument :filter, types.String, default_value: nil
  argument :order, types.String, default_value: '-id'
  argument :date, types.String
  argument :theater_id, types.Int
  argument :show_id, types.Int
  
  type types[ShowType]

  resolve(ShowsResolver.new)
end