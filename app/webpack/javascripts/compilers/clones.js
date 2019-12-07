up.compiler('[clones] ', function(button) {
  const target = document.querySelector(button.getAttribute('clones'));
  const cloneCopy = target.cloneNode(true);

  up.on(button, 'click', function(evt){
    target.parentNode.insertBefore(cloneCopy.cloneNode(true), target);
  });
});
