PersonType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Person'

  field :person_id, types.Int do
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
  field :imdb_code, types.String
end
