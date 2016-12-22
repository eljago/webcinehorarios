VideoType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Video'

  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id

  field :video_id, types.Int do
    resolve ->(obj, args, ctx) {
      obj.id
    }
  end
  field :name, types.String
  field :code, types.String
  field :outstanding, types.Boolean
  field :video_type, types.String
  field :show_id, types.Int
  field :image, types.String do
    resolve ->(obj, args, ctx) {
      obj.image_url
    }
  end

  field :show, ShowType
end
