React = require 'react'
{div, h1, p, ul, li, table, thead, tr, th, tbody} = require 'reactionary'

FilterableProductTable = require './views/item_container'

items = require './data.json'

# items = [
#   {name:'Bechamel', patternNumber:'938001', color_id:'20', color:'Mantis', price:'109', size:'54"', collection:'textile'}
#   {name:'Bechamel', patternNumber:'938001', color_id:'23', color:'Adams', price:'109', size:'54"', collection:'textile'}
#   {name:'Benderlock', patternNumber:'890001', color_id:'01', color:'Brucefield', price:'92', size:'58"', collection:'textile'}
#   {name:'Benderlock', patternNumber:'890001', color_id:'02', color:'Buckpool', price:'92', size:'58"', collection:'textile'}
# ]

# This is the main app entry point. For now we call FilterableProductTable
## and pass it some items data.
React.renderComponent FilterableProductTable(items: items), document.getElementById('content')
