up.compiler('.generator', function(form){
  const totalPartsInput = document.querySelector('input[name="total_parts"]')

  up.on('room:user-count-changed', function(evt){
    if(evt.userCount > 1){
      totalPartsInput.disabled = true;
      totalPartsInput.value = evt.userCount;
    }else{
      totalPartsInput.disabled = false;
    }
  });
});
