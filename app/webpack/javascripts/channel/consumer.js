import { createConsumer } from '@rails/actioncable'

window.consumer = createConsumer(window.location.protocol + '//' + window.location.host + '/ws')

up.compiler('body', () => {

  let currentRoomId = ''
  let roomChannel =  undefined;
  let userChannel = undefined;

  up.on('room_changed', () => {

    let roomRegex = /secrets\/(.+)\//
    let roomId = roomRegex.exec(window.location)[1]

    if(currentRoomId !== roomId){
      currentRoomId = roomId;

      if (userChannel) {
        userChannel.unsubscribe()
      }
      if(roomChannel) {
        roomChannel.unsubscribe()
      }

      function received(data) {
        if(data.type === 'message'){
          addFlash(data.message);
        }else if(data.type === 'file'){
          download('secret_part.txt', data.message);
        }else if(data.type === 'user-count-changed'){
          up.emit('room:user-count-changed', { userCount: data.message });
        }
      }

      roomChannel = consumer.subscriptions.create({ channel: "KeyExchangeChannel", room: roomId },{ received: received });
      userChannel = consumer.subscriptions.create({ channel: "UserChannel", room: roomId },{ received: received })

      function download(filename, text) {
        var element = document.createElement('a');
        element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
        element.setAttribute('download', filename);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);
      }

      function addFlash(message){
        const parser = new DOMParser();
        let alertDomString = `<div class='alert alert-info'>
       ${message}
       <button type='button' class='close' aria-label='Close'>
         <span aria-hidden> ×
     </div>
    `
        let parsedNode = parser.parseFromString(alertDomString, 'text/html').querySelector('.alert');
        let prependedNode = document.querySelector('.container').prepend(parsedNode);
        up.hello(parsedNode);
      }
    }

    return () => {
      if (userChannel) {
        userChannel.unsubscribe()
      }
      if(roomChannel) {
        roomChannel.unsubscribe()
      }
    }
  });


})
