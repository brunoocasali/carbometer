class Dashing.Gallery extends Dashing.Widget
  ready: ->
    $(".rslides").responsiveSlides
      speed: 2500
      timeout: 8000
