import { createConsumer } from '@rails/actioncable'

up.compiler('.room',() => {

  const roomRegex = /secrets\/(.+)\//
  const roomId = roomRegex.exec(window.location)[1]

  const channel = consumer.subscriptions.create({ channel: "UserChannel", room: roomId })

  return () => {
    channel.unsubscribe()
  }

});
