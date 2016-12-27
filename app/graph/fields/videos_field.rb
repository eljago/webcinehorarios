VideosField = GraphQL::Field.define do
  name('videos')

  argument :cacheTime, types.String
  argument :filter, types.String, default_value: nil
  argument :first, types.Int, default_value: 10
  argument :date, types.String
  
  type VideoType.connection_type

  resolve(VideosResolver.new)
end