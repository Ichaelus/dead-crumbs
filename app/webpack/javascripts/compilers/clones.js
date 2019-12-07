up.compiler('[clones] ', function(button) {
  const target = document.querySelector(button.getAttribute('clones'));
  const cloneCopy = target.cloneNode(true);
  let lastInserted = target;

  up.on(button, 'click', function(evt){
    let insertNode = target.parentNode.insertBefore(cloneCopy.cloneNode(true), lastInserted.nextElementSibling);
    up.hello(insertNode);
    lastInserted = insertNode;
  });
});
