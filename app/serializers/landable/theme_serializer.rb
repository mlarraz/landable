module Landable
  class ThemeSerializer < ActiveModel::Serializer
    attributes :id, :name, :editable, :body, :description, :thumbnail_url

    embed :ids
  end
end
