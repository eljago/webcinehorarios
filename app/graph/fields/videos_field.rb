VideosField = GraphQL::Field.define do
  name('videos')

  argument :cacheTime, types.String
  argument :filter, types.String, default_value: nil
  argument :page, types.Int, default_value: 1
  argument :date, types.String
  
  type types[VideoType]

  resolve(VideosResolver.new)
end