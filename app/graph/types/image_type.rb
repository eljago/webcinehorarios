ImageType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'ImageType'

  # `id` exposes the UUID
  global_id_field :id

  field :image_id, types.Int do
    resolve ->(obj, args, ctx) {
      obj.id
    }
  end
  field :width, types.Int
  field :height, types.Int
  field :poster, types.Boolean
  field :backdrop, types.Boolean
  field :image, types.String do
    resolve ->(obj, args, ctx) {
      obj.image_url
    }
  end
end
