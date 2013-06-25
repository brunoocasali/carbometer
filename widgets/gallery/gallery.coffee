class Dashing.Gallery extends Dashing.Widget
  ready: ->
    $('.slides').slidesjs
      play:
        effect: 'fade'
        interval: 5000
        auto: true
      pagination:
        active: false
      navigation:
        active: false
      effect:
        fade:
          speed: 300
          crossfade: true
