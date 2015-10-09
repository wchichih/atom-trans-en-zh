http = require 'http'

module.exports =
class TransEnZhView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('trans-en-zh')

    # Create translate result elements
    query = document.createElement('div')
    query.classList.add('query')
    @element.appendChild(query)

    translation = document.createElement('div')
    translation.classList.add('translation')
    @element.appendChild(translation)

    basic = document.createElement('div')
    basic.classList.add('basic')
    @element.appendChild(basic)

    web = document.createElement('div')
    web.classList.add('web')
    @element.appendChild(web)

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
    req.on "error", (e) ->
        console.log "Erorr: {e.message}"

  getNothing: ->
    console.log 'nothing'
    @element.children[0].innerHTML = '_(:з」∠)_  Nothing selected...'
    @element.children[1].innerHTML = ''
    @element.children[2].innerHTML = ''
    @element.children[3].innerHTML = ''

  gotIt: (data) =>
    console.log 'got it'
    jsonData = JSON.parse data
    if jsonData.errorCode == 0
      @element.children[0].innerHTML = jsonData.query
      @element.children[1].innerHTML = jsonData.translation
      pronounce = ''
      explains = ''
      webexplains = '<div class=\"webexplains\">网络释义</div>'
      if jsonData.basic != undefined
        if jsonData.basic['uk-phonetic'] != undefined
          pronounce = pronounce + '英 [' + jsonData.basic['uk-phonetic'] + ']    '
        if jsonData.basic['us-phonetic'] != undefined
          pronounce = pronounce + '美 [' + jsonData.basic['us-phonetic'] + ']    '
        else if jsonData.basic.phonetic != undefined
          pronounce = '[' + jsonData.phonetic + ']'
        pronounce = '<div class=\"pronounce\">' + pronounce + '</div><br />'
        if jsonData.basic.explains != undefined
          explains = explains + i + '<br />' for i in jsonData.basic.explains
      @element.children[2].innerHTML = pronounce + explains + '<hr />'
      if jsonData.web != undefined
        for item in jsonData.web
          webexplains = webexplains + item.key + ' : '
          for j in item.value
            webexplains = webexplains + j + '  '
          webexplains = webexplains + '<br />'
      @element.children[3].innerHTML = webexplains

    if jsonData.errorCode == 20
      @element.children[0].innerHTML = '要翻译的文本过长'
      @element.children[1].innerHTML = ''
      @element.children[2].innerHTML = ''
      @element.children[3].innerHTML = ''
    if jsonData.errorCode == 30
      @element.children[0].innerHTML = '无法进行有效的翻译'
      @element.children[1].innerHTML = ''
      @element.children[2].innerHTML = ''
      @element.children[3].innerHTML = ''
    if jsonData.errorCode == 40
      @element.children[0].innerHTML = '不支持的语言类型'
      @element.children[1].innerHTML = ''
      @element.children[2].innerHTML = ''
      @element.children[3].innerHTML = ''
    if jsonData.errorCode == 50
      @element.children[0].innerHTML = '无效的key'
      @element.children[1].innerHTML = ''
      @element.children[2].innerHTML = ''
      @element.children[3].innerHTML = ''
    if jsonData.errorCode == 60
      @element.children[0].innerHTML = '无词典结果，仅在获取词典结果生效'
      @element.children[1].innerHTML = ''
      @element.children[2].innerHTML = ''
      @element.children[3].innerHTML = ''
