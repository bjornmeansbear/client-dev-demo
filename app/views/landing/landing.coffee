React = require 'react/addons'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
{div, img, ul, ol, li, a, button, p, h1, h2, strong, span} = require 'reactionary'
_ = require 'lodash'
Hammer = require 'hammerjs'

SlideItem = require './slide_item'
Indicators = require './indicators'

module.exports = React.createClass
  getInitialState: ->
    startingSlide = _.random 0, @data.length-1
    activeSlide: startingSlide
    prevSlide: 0
    showNotice: app.me.showNotice

  componentWillMount: ->
    app.items.clearFilters()

  componentDidUpdate: ->
    clearInterval @interval
    @interval = setInterval @next, 10000

  componentDidMount: ->
    reactElement = document.getElementById('react')
    @mc = new Hammer(reactElement)
    @mc.on 'swipeleft', @next
    @mc.on 'swiperight', @prev
    @interval = setInterval @next, 7000

  componentWillUnmount: ->
    clearInterval @interval
    @mc.off 'swipeleft', @next
    @mc.off 'swiperight', @prev

  prev: ->
    if @state.activeSlide == 0
      @setState
        activeSlide: @data.length-1
        prevSlide: @data.length
    else
      @setState
        activeSlide: @state.activeSlide-1
        prevSlide: @state.activeSlide

  next: ->
    if @state.activeSlide == @data.length-1
      @setState
        activeSlide: 0
        prevSlide: 0
    else
      @setState
        activeSlide: @state.activeSlide+1
        prevSlide: @state.activeSlide

  data: [
    ['91034-02',  '910100-04', '730005-02', '92219-02',  '910104-01']
    ['890023-02', '92935-03',  '92902-04',  '92934-07',  '730012-05']
    ['945003-07', '890007-02', '890020-04', '730010-02', '92705-12']
    ['750002-21', '750005-15', '810001-17', '944001-06', '806017-03']
    ['910101-01', '92207-01',  '730002-05', '96002-05',  '810001-13']
    ['750009-06', '910097-07', '750004-04', '806024-01', '890014-01']
    ['806025-03', '720001-08', '910034-08', '730006-04', '910104-07']
    ['92219-03',  '92209-07',  '92213-12',  '750004-07', '750002-26']
    ['92933-05',  '92934-01',  '93703-04',  '806026-01', '944001-03']
  ]
  handleNoticeClose: ->
    @setState showNotice: false
    app.me.showNotice = false

  render: ->
    activeSlide = @state.activeSlide
    slideIds = @data[activeSlide]
    slideItems = slideIds.map (id, i) -> SlideItem
      key: id
      model: app.items.get(id)
      i: i
    slideImg = "http://rogersandgoffigon.imgix.net/group/160516_rg_"+(activeSlide+1)+".jpg?w=1500"
    if @state.activeSlide < @state.prevSlide
      transitionClass = 'carousel-right'
    else
      transitionClass = 'carousel-left'
    noticeBoxClassName = if @state.showNotice then 'sorry-world' else 'hidden'

    div
      id: 'landing',
        div id: 'fixit-wrap',
          div className: 'slide',
            a
              href: '#collection',
                ReactCSSTransitionGroup
                  transitionName: transitionClass,
                    img
                      src: slideImg
                      key: slideImg
            ul
              className: 'image-map',
                slideItems
          Indicators
            slides: @data
            activeSlide: activeSlide
            setLanderState: (newSt) => @setState newSt

          a
            role: 'button'
            onClick: @prev
            className: 'left control',
              'Previous'
          a
            role: 'button'
            onClick: @next
            className: 'right control',
              'Next'

        div
          id: 'notice-box'
          className: noticeBoxClassName,
            div
              className: 'blanket bg-cream clearfix',
                a
                  href: '#trade/login',
                    h1 'Rogers & Goffigon'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/860003-02.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Montacute'
                            p
                              className: 'color m0 fs1',
                                'Venusta'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/700001-03.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Thumbelina'
                            p
                              className: 'color m0 fs1',
                                'Constable'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/92702-01.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Cervo'
                            p
                              className: 'color m0 fs1',
                                'Tusk'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/92508-04.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Mission Cloth'
                            p
                              className: 'color m0 fs1',
                                'Nest'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/740016-01.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Apex'
                            p
                              className: 'color m0 fs1',
                                'Alp'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/750006-06.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Coda'
                            p
                              className: 'color m0 fs1',
                                'Salvia'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/92927-04.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Seed Pearl'
                            p
                              className: 'color m0 fs1',
                                'Moonlight'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/880005-01.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Mezzo'
                            p
                              className: 'color m0 fs1',
                                'Rene'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/740013-03.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Glen'
                            p
                              className: 'color m0 fs1',
                                'Mammoth'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/92929-01.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Pongee'
                            p
                              className: 'color m0 fs1',
                                'Champagne'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/750005-05.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Merlin'
                            p
                              className: 'color m0 fs1',
                                'Minnow'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/870004-14.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Serge de Nimes'
                            p
                              className: 'color m0 fs1',
                                'Ocelot'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/92530-05.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Scarp'
                            p
                              className: 'color m0 fs1',
                                'Aquifer'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/910099-01.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Cross Hatch'
                            p
                              className: 'color m0 fs1',
                                'Hopsack'
                    div
                      className: 'block summerSale',
                        img
                          src: 'http://rogersandgoffigon.imgix.net/normal/910094-08.jpg?w=240&h=240&crop=focalpoint&fit=crop&fp-x=.5&fp-y=.5&fp-z=2'
                        div
                          className: 'caption',
                            p
                              className: 'name m0 fs1',
                                'Stromboli'
                            p
                              className: 'color m0 fs1',
                                'Paglia'
                    div
                      className: 'clear p1p5 customType textReplace',
                        h2
                          className: 'mb1',
                            'New Additions to the Summer Sale Section of our Website!'
                        p
                          className: 'mb1 mw30em mlrauto',
                            'If you are a To The Trade client you can shop the Summer Sale
    section of the Rogers & Goffigon website.'
                        p 'Have an existing account with us but don’t know your login information?'
                        p 'Use your full account number as your user name and ZIP code as your password.'
                        p 'International accounts: use your country name as your password.'
                        p 'Accounts are available to the trade only.'
          button
            className: 'close'
            onClick: @handleNoticeClose,
              'Close'
