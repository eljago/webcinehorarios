ShowField = GraphQL::Field.define do
  name('show')

  argument :cacheTime, types.String
  argument :show_id, types.Int
  
  type ShowType

  resolve(ShowResolver.new)
end