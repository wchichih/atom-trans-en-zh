http = require 'http'

module.exports =
class TransEnZhView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('trans-en-zh')

    # Create message element
    message = document.createElement('div')
    # message.textContent = '233'
    # message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  getYoudao: (lookup, callback) ->
    data = ''
    lookup = encodeURI(lookup)
    options =
        host: 'fanyi.youdao.com'
        path: '/openapi.do?keyfrom=atom-trans-en-zh&key=769450225&type=data&doctype=json&version=1.1&q='+lookup
    req = http.get options, (res) ->
        res.on 'data', (chunk) ->
            data += chunk
        res.on 'end', () ->
            callback(data)
            console.log typeof(data)
    req.on "error", (e) ->
        console.log "Erorr: {e.message}"
    console.log '233'

  getNothing: ->
    console.log 'nothing'
    @element.children[0].textContent = '_(:з」∠)_  Nothing selected...'

  gotIt: (data) =>
    console.log 'got it'
    @element.children[0].textContent = data
