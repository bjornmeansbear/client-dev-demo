React = require 'react'
{div, ul, li, button} = require 'reactionary'

Items = require './items'

module.exports = React.createClass
  categoryClick: (e) ->
    @props.setRouterState
      patternNumber: false
      id: false
      category: e.target.value

  render: ->
    if @props.active
      itemList = Items
        collection: @props.collection
        initState: @props.initState
        setRouterState: @props.setRouterState
    else
      itemList = div {}

    return div
      className: 'row'
      id: 'collection-row-'+@props.category,
        ul
          className: 'collection-controls',
            li
              className: 'hug-center on-top',
                button
                  className: 'uppercase'
                  onClick: @categoryClick
                  value: @props.category,
                    @props.label or @props.category
        itemList
