loadImage = (src, callback) ->
  img = new Image
  img.onload = -> callback? img
  img.src = src

module.exports = loadImage
