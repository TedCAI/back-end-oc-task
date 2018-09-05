App.TeamChannel = App.cable.subscriptions.create { channel: "TeamChannel", room: "maze" },
  received: (data) ->
    window.location.href = data["body"]

  connected: () ->

  disconnected: () ->
    App.cable.subscriptions.remove(this)
    this.perform('unsubscribed')


$(document).on 'click', '.final', () ->
  App.TeamChannel.disconnected()