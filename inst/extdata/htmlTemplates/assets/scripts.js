{
  
    function selectText(containerid) {
        if (window.getSelection) {
          if (window.getSelection().empty) {  // Chrome
            window.getSelection().empty();
          } else if (window.getSelection().removeAllRanges) {  // Firefox
            window.getSelection().removeAllRanges();
          }
        } else if (document.selection) {  // IE?
          document.selection.empty();
        }
        if (document.selection) {
            var range = document.body.createTextRange();
            range.moveToElementText(document.getElementById(containerid));
            range.select();
        } else if (window.getSelection) {
            var range = document.createRange();
            range.selectNode(document.getElementById(containerid));
            window.getSelection().addRange(range);
        }
    }

    function downloadFig(id, ext) {
      var name = './img/'.concat(id).concat(ext);
      window.open(name);
    }

    function showCode(id) {
      if (document.getElementById(id.concat('_check')).checked) {
          document.getElementById(id.concat('_hidden')).style.display  = 'block';
      } else {
          document.getElementById(id.concat('_hidden')).style.display  = 'none';
      }
    }

}
