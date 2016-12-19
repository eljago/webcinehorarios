VideosField = GraphQL::Field.define do
  name('videos')

  argument :cacheTime, types.String
  argument :page, types.Int, default_value: 1
  
  type types[VideoType]

  resolve(VideosResolver.new)
end