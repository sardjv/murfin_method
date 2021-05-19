import CableReady from 'cable_ready'
import consumer from './consumer'

if($("meta[name='user_logged_in']")) {
  consumer.subscriptions.create("FlashMessagesChannel", {
    connected() {
      // console.log('FlashMessagesChannel | connected')
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // console.log('FlashMessagesChannel | disconnected')
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // console.log('FlashMessagesChannel | received', data)
      if (data.cableReady) CableReady.perform(data.operations)
      // Called when there's incoming data on the websocket for this channel
    }
  })
}
