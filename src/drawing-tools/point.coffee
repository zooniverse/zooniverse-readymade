BasePoint = require 'marking-surface/lib/tools/point'
{SVG} = require 'marking-surface'

class Point extends BasePoint
  @Controls: require './tool-controls'

  unit: ''
  upp: 0 # Units per pixel
  precision: 0 # Decimal places

  constructor: ->
    super

    @coordsGroup = SVG::addShape.call @, 'g.readymade-coordinates-label'
    @coordsRect = @coordsGroup.addShape 'rect', x: -5
    @coordsLabel = @coordsGroup.addShape 'text'

  rescale: (scale) ->
    super

    @coordsLabel.el.style.fontSize = ''
    fontSize = parseFloat getComputedStyle(@coordsLabel.el).fontSize
    @coordsLabel.el.style.fontSize = "#{fontSize / scale}px"

  onMove: (e) ->
    # Override to remove pointer offset.
    {x, y} = @coords e
    @mark.set {x, y}

  render: ->
    super

    @attr 'data-show-coordinates', (@unit and @upp) or null

    x = (@mark.x / @upp).toFixed(@precision) + @unit
    y = (@mark.y / @upp).toFixed(@precision) + @unit

    @coordsLabel.attr 'textContent', "#{x}, #{y}"

    # TODO: This is too tall for some reason.
    labelBox = @coordsLabel.el.getBBox()

    @coordsRect.attr
      y: -labelBox.height - 5
      width: labelBox.width + 5
      height: labelBox.height + 10

    labelX = labelBox.width / -2
    labelY = labelBox.height + parseFloat @disc.attr('r') || @radius

    @coordsGroup.attr 'transform', "translate(#{Math.floor labelX}, #{Math.floor labelY})"

module.exports = Point
