CountryType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Country'

  field :country_id, types.Int do
    resolve ->(obj, args, ctx) {
      obj.id
    }
  end
  field :name, types.String
  field :image, types.String do
    resolve ->(obj, args, ctx) {
      obj.image_url
    }
  end
  field :shows, types[ShowType]
end
