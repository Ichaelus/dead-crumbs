up.compiler('[maybe-file-input] ', function(container) {
  const fileInput = container.querySelector('input[type="file"]');
  const otherInput = container.querySelector('input:not([type="file"])');

  up.on(fileInput, 'change', function(evt){
    const file = evt.target.files[0]; // FileList object
    const reader = new FileReader();
    if(file && reader){
      reader.readAsText(file, "UTF-8");
      reader.onload = function (readEvt) {
        otherInput.value = readEvt.target.result;
      }
      reader.onerror = function (readEvt) {
        console.table(['Could not read file contents', readEvt]);
      }
    }
  });
})
