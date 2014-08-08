React = require 'react'
{div, button, ul, li, a, img} = require 'reactionary'

module.exports = React.createClass
  getInitialState: ->
    pg: 0
    pgSize: 5

  propTypes:
    collection: React.PropTypes.object.isRequired

  handleColorClick: (e) ->
    color_id = e.target.id
    href = e.target.parentElement.hash.substr(1)
    if e.preventDefault
      e.preventDefault()
    #console.log href
    app.router.navigate(href, {replace: true})
    @props.setContainerState color_id: color_id

  handleUnitClick: (e) ->
    unit = e.target.value
    if e.preventDefault
      e.preventDefault()
    @setState unit: unit

  handleXclick: (e) ->
    if e.preventDefault
      e.preventDefault()
    @props.setParentState colorBoxView: false

  loadMetricRuler: ->
    unless @state.loadedMetric
      item = @props.model
      ruler_img = new Image()
      ruler_img.src = item.rulerPath.cm[@props.imgSize]
      console.log 'prefetch metric ruler ' + ruler_img.src
      @setState loadedMetric: true

  render: ->
    pages = Math.ceil(@props.collection.length / 5)
    if pages > 1
      pager_txt = (@state.pg+1) + ' / ' + pages
    else
      pager_txt = ''

    closeButton = button
      key: 'close'
      className: 'close'
      onClick: @handleXclick
      type: 'button',
        'X'

    header = div
      className: 'colors-header',
        pager_txt, closeButton
    offset = @state.pg * @state.pgSize
    limit = (@state.pg + 1) * @state.pgSize
    pageItems = @props.collection.models.slice(offset, limit)
    relatedColorItems = []
    pageItems.forEach (item) =>
      relatedColorItems.push li
        key: item.id
        className: 'related-item',
          a
            onClick: @handleColorClick
            href: item.detail,
              img
                id: item.color_id
                src: item._file.small.path
                alt: item.color

    relatedColorsList = ul
      className: 'list-inline list',
        relatedColorItems

    return div
      id: 'related-colors'
      className: 'hidden-xs',
        header, relatedColorsList