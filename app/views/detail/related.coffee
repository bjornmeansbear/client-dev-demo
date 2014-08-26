React = require 'react'
{div, button, ul, li, a, img, i} = require 'reactionary'

CloseButton = require '../el/button_close'
ItemEl = require '../collection/item_el'

module.exports = React.createClass

  getInitialState: ->
    pg: 0
    pgSize: 5
    pages: Math.ceil(@props.collection.length / 5)
    prevActive: false
    nextActive: true

  propTypes:
    collection: React.PropTypes.object.isRequired
    setParentState: React.PropTypes.func.isRequired
    setContainerState: React.PropTypes.func.isRequired
    patternNumber: React.PropTypes.string.isRequired

  handleColorClick: (e) ->
    unless @props.section == 'collection'
      color_id = e.target.id
      href = e.target.parentElement.hash.substr(1)
      if e.preventDefault
        e.preventDefault()
      app.container.router.navigate href, replace: true
      @props.setParentState isRelated: true
      @props.setContainerState color_id: color_id

  handleColorDown: (e) ->
    @props.setParentState
      loadedLarge: false
      showRuler: false
    id = @props.patternNumber + '-' + e.target.id
    console.log id
    item = @props.collection.get(id)
    itemImg = new Image()
    itemImg.onload = @loadedLarge
    itemImg.src = item._file.large.path
    return

  handleUnitClick: (e) ->
    unit = e.target.value
    if e.preventDefault
      e.preventDefault()
    @setState unit: unit

  handleXclick: (e) ->
    if e.preventDefault
      e.preventDefault()
    @.props.setParentState colorBoxView: false

  handleNextClick: (e) ->
    if e.preventDefault
      e.preventDefault()
    if (@state.pg+1) < @state.pages
      @setState pg: @state.pg+1

  handlePrevClick: (e) ->
    if e.preventDefault
      e.preventDefault()
    if @state.pg > 0
      @setState pg: @state.pg-1

  loadedLarge: ->
    console.log 'finished loading image!'
    @props.setParentState
      loadedLarge: true
      showRuler: true

  render: ->
    itemCount = @props.collection.length
    pages = @state.pages
    if pages > 1
      pager = true
      pager_txt = (@state.pg+1) + ' / ' + pages
    else
      pager_txt = false

    # Header
    header = div
      className: 'colors-header',
        pager_txt
        CloseButton
          onClick: @handleXclick
    offset = @state.pg * @state.pgSize
    limit = (@state.pg + 1) * @state.pgSize
    pageItems = @props.collection.models.slice(offset, limit)

    # Color icons.
    relatedColorItems = []
    pageItems.forEach (item) =>
      relatedColorItems.push li
        key: item.id
        className: 'related-item',
          ItemEl
            model: item
            imgSize: 'small'
            onClick: @handleColorClick
            onMouseDown: @handleColorDown

    relatedColorsList = ul
      className: 'list-inline list',
        relatedColorItems

    # Colors row.
    if pager
      relatedColorsRow = div {},
          button
            onClick: @handlePrevClick
            className: 'left rel-previous',
              '<'
          relatedColorsList
          button
            onClick: @handleNextClick
            className: 'right rel-next',
              '>'
    else
      relatedColorsRow = relatedColorsList

    if itemCount < 5
      colorsClass = 'hidden-xs size-'+itemCount
    else
      colorsClass = 'hidden-xs size-5'
    if pager
      colorsClass += ' pager'
    return div
      id: 'related-colors'
      className: colorsClass,
        header, relatedColorsRow
