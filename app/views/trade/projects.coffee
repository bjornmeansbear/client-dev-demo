React = require 'react'
{div, ul, li, button, span, input, a} = require 'reactionary'
_ = require 'lodash'

Favs = require '../favs_content'
NewProject = require '../el/project_new'
Share = require '../share'

module.exports = React.createClass
  getInitialState: ->
    editName: null
    projects: app.me.projects
    addProject: false
    projectLength: 0

  componentDidMount: ->
    window.placeholder = document.createElement("li")
    window.placeholder.className = "placeholder"
    # Listen for project changes.
    app.me.projects.on 'change', @handleLoaded

  componentWillUnmount: ->
    app.me.projects.off 'change', @handleLoaded

  # EVENT HANDLERS
  handleLoaded: (project) ->
    #console.log 'load project '+project.id
    @setState projectsLength: @state.projectsLength+1

  handleEdit: (e) ->
    if @state.editName == e.target.value
      @setState editName: null
      @_saveName() #closing should save
    else
      if @state.editName #switching should save.
        @_saveName()
      @setState editName: e.target.value

  handleDelete: (e) ->
    if confirm 'Are you sure you want to delete this project? This cannot be undone.'
      app.me.projects.get(e.target.value).destroy
        error: ->
          alert('There was an error destroying the task')
        success: ->
          console.log 'gone'
      @forceUpdate()

  changeName: (e) ->
    newName = @refs.newName.getDOMNode().value
    id = @state.editName
    app.me.projects.get(id).name = newName
    @state.projects = app.me.projects
    @forceUpdate()
    # Update the project name.

  keyDown: (e) ->
    if e.key and e.key == 'Enter'
      @_saveName()
    return

  _saveName: ->
    id = @state.editName
    project = app.me.projects.get(id)
    @setState editName: null
    # Save it to the db.
    project.save name: project.name

  newProject: (name) ->
    app.me.projects.create
      name: name
    @setState addProject: false

  # Dragging

  dragStart: (e) ->
    unless e.target.localName == 'li'
      e.preventDefault()
      return
    @.dragged = e.currentTarget
    e.dataTransfer.effectAllowed = 'move'
    e.dataTransfer.setData('text/html', e.currentTarget)
    return

  dragOver: (e) ->
    e.preventDefault()
    @dragged.style.display = "none"
    if e.target.className == "placeholder" then return
    @over = e.target
    relY = e.clientY - @over.offsetTop
    height = @over.offsetHeight / 2
    parent = e.target.parentNode

    if relY > height
      @nodePlacement = "after"
      parent.insertBefore(window.placeholder, e.target.nextElementSibling)
    else if relY < height
      @nodePlacement = "before"
      parent.insertBefore(window.placeholder, e.target)
    return

  dragEnd: (e) ->
    @dragged.style.display = "block"
    @dragged.parentNode.removeChild(window.placeholder)
    data = @state.projects.pluck('id')
    from = Number(this.dragged.dataset.id)
    to = Number(this.over.dataset.id)
    if from < to then to--
    if this.nodePlacement == "after" then to++
    data.splice(to, 0, data.splice(from, 1)[0])
    app.me.projects.saveOrder(data)
    @setState projects: app.me.projects
    #console.log @state.projects.pluck('id')#from, to
    #@forceUpdate()
    return

  # HTML

  nameTxt: (name, id) ->
    if id == @props.initState.projectId
      link = '#trade/projects'
    else
      link = '#trade/projects/'+id
    span
      draggable: false
      className: 'list-name',
        a
          draggable: false
          href: link,
            name

  nameForm: (name) ->
    input
      value: name
      onChange: @changeName
      ref: 'newName'
      onKeyDown: @keyDown

  project: (project, i) ->
    if @state.editName == project.id
      name = @nameForm project.name
    else
      name = @nameTxt project.name, project.id

    if project.id == @props.initState.projectId
      projectItems = Favs @props
      share = Share
        shareUrl: project.shortUrl
    else
      projectItems = false
      share = false

    isDraggable = !(@props.initState.projectId)
    li
      'data-id': i
      key: project.id
      draggable: isDraggable
      onDragStart: @dragStart
      onDragEnd: @dragEnd
      className: 'project ' +isDraggable,
        share
        name
        span
          className: 'list-edit',
            button
              className: 'edit',
              onClick: @handleEdit
              value: project.id,
                'edit'
            button
              className: 'delete',
              onClick: @handleDelete
              value: project.id,
                'delete'
        projectItems

  render: ->
    if @state.projects and @state.projects.length and @state.projects.models[0].name
      projects = _.filter @state.projects.models, (model) -> model.name
      projects = projects.map @project
    else
      projects = 'No projects.'
    if @state.addProject
      newProj = NewProject
        onClose: => @setState addProject: false
        onSave: @newProject
    else
      newProj = false

    div
      className: 'trade-projects',
        div
          className: 'row',
            button
              onClick: => @setState addProject: true
              className: 'new-project btn-outline',
                'Add New Project'
            newProj
        div
          className: 'existing-projects',
            ul
              onDragOver: @dragOver,
                projects
