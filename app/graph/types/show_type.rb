ShowType = GraphQL::ObjectType.define do
  name "Show"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :show_id, types.Int do
    resolve -> (show, args, ctx) {
      show.id
    }
  end
  field :name, types.String
  field :image_url, types.String
  field :information, types.String
  field :duration, types.Int
  field :name_original, types.String
  field :rating, types.String
  field :year, types.Int
  field :imdb_code, types.String
  field :imdb_score, types.Int
  field :metacritic_url, types.String
  field :metacritic_score, types.Int
  field :rotten_tomatoes_url, types.String
  field :rotten_tomatoes_score, types.Int

  field :has_functions, types.Boolean do
    resolve -> (show, args, ctx) {
      !show.functions.where('functions.date = ?',Date.current).count.zero?
    }
  end

  field :debut, types.String do
    resolve -> (show, args, ctx) {
      show.debut.blank? ? nil : I18n.l(show.debut, format: :longi).capitalize
    }
  end

  field :genres, types.String do
  	resolve -> (show, args, ctx) {
  		show.genres.map(&:name).join(', ')
  	}
  end

  field :functions, types[ShowFunctionType]

  field :people, types[PersonType] do
    resolve -> (show, args, ctx) {
      show.show_person_roles
    }
  end

  field :videos, types[VideoType]
  field :portrait_image, ImageType
  field :images, types[ImageType]
end