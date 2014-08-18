url = require 'url'
_ = require 'underscore'
Router = require 'ampersand-router'
itemsFilter = require './models/itemsFilter'

defaultCategory = 'textile'

module.exports = Router.extend
  pop: 'ka'
  itemsFilter: itemsFilter
  routes:
    '': -> @redirectTo('pricelist')
    'cl': -> @redirectTo('collection/'+defaultCategory+'/3')
    'collection': -> @redirectTo('collection/'+defaultCategory+'/3')
    'collection/:category': 'collection'
    'collection/:category/:pgSize': 'collection'
    'collection/:category/:pgSize(/:query)/p:page': 'collection'
    'pl': -> @redirectTo('pricelist/'+defaultCategory+'/50/p1')
    'plp': -> @redirectTo('pricelist/passementerie/50/p1')
    'pricelist': -> @redirectTo('pricelist/'+defaultCategory+'/50/p1')
    'pricelist/:category': 'pricelist'
    'pricelist/:category/:pgSize': 'pricelist'
    'pricelist/:category/:pgSize(/:query)/p:page': 'pricelist'
    'detail/:pattern/:id': 'detail'

  collection: (category, pgSize, searchTxt, pageIndex) ->
    S = _.extend @getQuery(),
      section: 'collection'
      category: category
      pgSize: pgSize
      searchTxt: searchTxt
      pageIndex: pageIndex

    S = @prepNewState S

    @setReactState S

  pricelist: (category, pgSize, searchTxt, pageIndex) ->
    #console.log 'pricelist'
    S = @prepNewState
      section: 'pricelist'
      category: category
      pgSize: pgSize
      searchTxt: searchTxt
      pageIndex: pageIndex
    @setReactState S

  detail: (patternNumber, color_id) ->
    #console.log 'detail'
    newState =
      section: 'detail'
      patternNumber: patternNumber
      hasDetail: true
      color_id: color_id
    itemsFilter app.items, newState
    @setReactState newState

  isItemNumber: (possibleId) ->
    /^(P-|L-)?[0-9]{4,7}-[0-9]{2}[LD]?$/.test(possibleId)

  isPatternNumber: (possiblePattern) ->
    /^(P-|L-)?[0-9]{4,7}$/.test(possiblePattern)

  getQuery: ->
    get = (url.parse @history.fragment, true).query
    unless get
      return {}
    q = {}
    if get.id and @isItemNumber(id = get.id.toUpperCase())
      q.id = id
    else if get.pattern
      if @isPatternNumber(patternNumber = get.pattern.toUpperCase())
        q.patternNumber = patternNumber
    q

  setQuery: (s) ->
    if s.id
      q = id: s.id
    else if s.patternNumber
      q = pattern: s.patternNumber
    else
      return ''
    url.format query: q

  # Prep state object for collection and pricelist section views.
  prepNewState: (s) ->
    newState = {}
    newState.section = s.section
    newState.patternNumber = s.patternNumber
    newState.id = s.id
    newState.searchTxt = @searchTxtParse s.searchTxt

    newState.category = switch s.category
      when 't' then 'textile'
      when 'textile' then 'textile'
      when 'p' then 'passementerie'
      when 'passementerie' then 'passementerie'
      when 'trim' then 'passementerie'
      when 'l' then 'leather'
      when 'leather' then 'leather'
      when 'skin' then 'leather'
      when 'hide' then 'leather'
      else 'textile'

    newState.filterOptions = switch newState.category
      when 'textile' then ['content', 'color', 'description']
      when 'passementerie' then ['color', 'description']
      when 'leather' then ['type', 'color']
    newState.filterFields = {}

    if s.pageIndex
      newState.pageIndex = parseInt s.pageIndex
      if !newState.pageIndex > 0
        newState.pageIndex = 1
    else
      newState.pageIndex = 1

    # Default to HIDE color_id 00.
    newState.omit00 = true
    if 'collection' == s.section
      newState.hasImage = true
      newState.colorSorted = true
      pgSizes = [3, 21, 42, 84]
      if 'passementerie' == newState.category
        favsOnly = false
        pgSizes.shift()
      else
        favsOnly = true
    else if 'pricelist' == s.section
      pgSizes = [50, 100, 10000]
    else
      pgSizes = [1]

    newState.pgSize = @closest s.pgSize, pgSizes
    newState.pgSizes = pgSizes
    redirected = @updateURL s, newState

    # filter the items
    itemsFilter app.items, newState

    if 3 == newState.pgSize
      newState.totalPages = app.items.filtered_length
    else
      newState.totalPages =
        Math.ceil(app.items.filtered_length / newState.pgSize)
    if newState.totalPages and newState.pageIndex > newState.totalPages
      newState.pageIndex = newState.totalPages
      @updateURL oldState, newState
    #console.log newState
    return newState

  searchTxtParse: (searchTxt) ->
    if typeof searchTxt == 'string'
      # Make sure the user input search text is lowercase.
      searchTxt = searchTxt.toLowerCase()
      # Make sure the text string is valid... Regex check.
      searchTxt = searchTxt.replace(/[^a-z0-9-\s]/, '')
      return searchTxt
    else
      return ''

  urlCreate: (s) ->
    urlTxt = s.section+'/'+s.category+'/'+s.pgSize
    if s.searchTxt
      urlTxt += '/' + s.searchTxt
    urlTxt += '/p' + s.pageIndex + @setQuery(s)

    return urlTxt

  updateURL: (oldSt, newSt) ->
    newStateURL = @urlCreate newSt
    oldURL = @urlCreate oldSt
    if newStateURL != oldURL
      #console.log newStateURL + ' - ' + oldURL
      @redirectTo newStateURL
      return true
    else
      return false

  closest: (goal, arr) ->
    if 'all' == goal or 'max' == goal
      return arr[arr.length - 1]
    else
      goal = parseInt(goal)
    # First element in array is the default page size.
    nearest = num = arr[0]
    diff = Math.abs(num - goal)
    if diff == 0
      nearest = num
    else
      for num in arr
        newDiff = Math.abs(num - goal)
        if newDiff < diff
          nearest = num
    return nearest
