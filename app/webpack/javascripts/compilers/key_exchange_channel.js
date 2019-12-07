import { createConsumer } from '@rails/actioncable'

up.compiler('body',() => {

  const roomRegex = /secrets\/(.+)\//
  const roomId = roomRegex.exec(window.location)[1]

  window.consumer = createConsumer('http://' + window.location.host + '/ws')

  consumer.subscriptions.create({ channel: "KeyExchangeChannel", room: roomId },{
    received(data) {
      if(data.type === 'message'){
          alert(data.message)
      }
    }
  })

});
