ShowType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'ShowType'

  # `id` exposes the UUID
  global_id_field :id

  field :name, types.String
  field :name_original, types.String
  field :active, types.Boolean
  field :debut, types.String
  field :duration, types.Int
  field :year, types.Int
  field :information, types.String
  field :imdb_code, types.String
  field :imdb_score, types.Int
  field :metacritic_url, types.String
  field :metacritic_score, types.Int
  field :rotten_tomatoes_url, types.String
  field :rotten_tomatoes_score, types.Int
  field :cover, types.String do
    resolve ->(obj, args, ctx) {
      obj.image_url
    }
  end

  field :functions, types[QlFunctionType]
end
