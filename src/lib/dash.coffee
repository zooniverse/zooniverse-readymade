dash = (string) ->
  string.toLowerCase().replace /\W+/g, '-'

module.exports = dash
