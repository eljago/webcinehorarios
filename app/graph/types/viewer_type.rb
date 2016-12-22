ViewerType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Viewer'
  description 'Support unassociated root queries that fetches collections.'
  interfaces [GraphQL::Relay::Node.interface]

  # `id` exposes the UUID
  global_id_field :id

  field :theaters, TheatersField
  field :shows, ShowsField
  field :show, ShowField
  field :videos, VideosField
end
