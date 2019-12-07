up.compiler('.generator', function(form){
  const totalPartsInput = document.querySelector('input[name="total_parts"]')

  up.on('room:user-count-changed', function(evt){
    if(evt.userCount > 1){
      totalPartsInput.min = totalPartsInput.max = totalPartsInput.value = evt.userCount;
    }else{
      totalPartsInput.min = 2;
      totalPartsInput.max = undefined;
    }
  });
});
