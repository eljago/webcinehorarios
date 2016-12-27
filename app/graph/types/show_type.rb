ShowType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Show'

  field :show_id, types.Int do
    resolve ->(obj, args, ctx) {
      obj.id
    }
  end
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
  field :rating, types.String

  field :images, types[ImageType]
  field :functions, types[QlFunctionType]
  field :videos, types[VideoType]
  
  field :genres, types.String do
    resolve ->(obj, args, ctx) {
      obj.genres.map(&:name).join(', ')
    }
  end

  field :cover, types.String do
    resolve ->(obj, args, ctx) {
      obj.image_url
    }
  end

  field :cast, types[ShowPersonRoleType] do
    resolve ->(obj, args, ctx) {
      obj.show_person_roles.includes(:person)
    }
  end

end
