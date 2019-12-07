up.compiler('.room',() => {
  const roomRegex = /secrets\/(.+)\//
  const roomId = roomRegex.exec(window.location)[1]

  function received(data) {
    if(data.type === 'message'){
      addFlash(data.message);
    }else if(data.type === 'file'){
      download('secret_part.txt', data.message);
    }else if(data.type === 'user-count-changed'){
      up.emit('room:user-count-changed', { userCount: data.message });
    }
  }

  const roomChannel = consumer.subscriptions.create({ channel: "KeyExchangeChannel", room: roomId },{ received: received });
  const userChannel = consumer.subscriptions.create({ channel: "UserChannel", room: roomId },{ received: received })

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


  return () => {
    userChannel.unsubscribe()
    roomChannel.unsubscribe()
  }
});
