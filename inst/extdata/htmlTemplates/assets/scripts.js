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

    function checkTables() {

      $('.table').each(function() {
        tableScroll  = $(this).get(0).scrollWidth;
        tableWidth = $(this).parent().width();

        if (tableScroll > tableWidth) {
          alertMsg = '<div class="alert alert-warning alert-dismissible" role="alert">  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>  <strong>Warning!</strong> This table is wider than the document and needs to be scrolled. Use the parameter "tableSplit" for better readability.</div>'
          $(this).parent().parent().append(alertMsg);
        }
      });
    }

    $(document).ready(checkTables());

}
