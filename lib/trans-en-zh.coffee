TransEnZhView = require './trans-en-zh-view'
{CompositeDisposable} = require 'atom'

module.exports = TransEnZh =
  transEnZhView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @transEnZhView = new TransEnZhView(state.transEnZhViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @transEnZhView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'trans-en-zh:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @transEnZhView.destroy()

  serialize: ->
    transEnZhViewState: @transEnZhView.serialize()

  toggle: ->
    console.log 'TransEnZh was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
