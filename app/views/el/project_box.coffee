React = require 'react'
{div, p, button, a, select, option, label} = require 'reactionary'

# Confirm item added to favorites
CloseButton = require './button_close'
NewProject = require '../el/project_new'

module.exports = React.createClass
  getInitialState: ->
    selected: app.me.projects.at(0).id
    addProject: false

  selectNew: (model) ->
    @setState selected: model.id

  newProject: (name) ->
    app.me.projects.create {name: name}, {success: @selectNew, wait: true}
    @setState addProject: false

  close: ->
    @props.setItemState projectBoxView: false

  addItem: ->
    project = app.me.projects.get(@state.selected)
    project.addEntity @props.model.id
    @props.setItemState projectBoxView: false
    return

  render: () ->
    unless @props.itemState.projectBoxView
      return false
    options = app.me.projects.map (project) ->
      if project.name
        option
          key: project.id
          value: project.id,
            project.name

    if @state.addProject
      createNewProject = NewProject
        onClose: => @setState addProject: false
        onSave: @newProject
    else
      createNewProject =
        button
          type: 'button'
          onClick: => @setState addProject: true,
          'Create new list'
    div
      id: "project-list-select"
      className: "favorite popup",
        CloseButton
          onClick: @close
        div
          className: "select-group",
            label
              htmlFor: "project-trade-list",
                'Add to'
            select
              value: @state.selected
              onChange: (e) =>
                @setState selected: e.target.value
              id: "project-trade-list",
                options
        button
          type: 'submit'
          onClick: @addItem
          className: "btn-outline",
            'Add'
        div
          className: 'new-project row',
            createNewProject
