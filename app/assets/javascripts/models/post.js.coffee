class Carbometer.Model.Post extends Backbone.Model
  initialize: (attributes) ->
    @set title: attributes.title
    @set author_name: attributes.author_name
    @set published_at: attributes.published_at
    @set path: attributes.path
    @set visit_sum: attributes.visit_sum
    @set comment_count: attributes.comment_count
