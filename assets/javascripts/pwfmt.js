if (window.pwfmt == null) {
  window.pwfmt = {
    insertFormatHidden: function(doc, fieldId, format) {
      var hiddenId = 'pwfmt-format-' + fieldId;
      if (doc.getElementById(hiddenId) != null) {
        return;
      }
      var field = doc.getElementById(fieldId);
      var hidden = doc.createElement('input');
      hidden.type = 'hidden';
      hidden.id = hiddenId;
      hidden.className = 'pwfmt-format';
      hidden.name = 'pwfmt[formats][' + fieldId + ']';
      hidden.value = format;
      field.parentNode.appendChild(hidden);
      // field.after(
      //   '<input type="hidden" id="pwfmt-format-#{field_id}" class="pwfmt-format" name="pwfmt[formats][#{field_id}]" value="#{format}">'
      // );
    },
    insertFormatSelector: function(doc, fieldId, format, formats, toolbar) {
      var selectorId = 'pwfmt-select-' + fieldId;
      if (doc.getElementById(selectorId) != null) {
        return;
      }

      var select = doc.createElement('select');
      select.id = selectorId;
      select.className = 'pwfmt-select';
      select.dataset.target = fieldId;
      formats.forEach(function(fmt) {
        var opt = doc.createElement('option');
        opt.value = fmt[1];
        opt.text = fmt[0];
        opt.selected = opt.value === format;
        select.options.add(opt);
      });
      select.addEventListener(
        'change',
        function() {
          var hidden = doc.getElementById('pwfmt-format-' + fieldId);
          if (hidden == null) {
            return;
          }
          hidden.value = this.options[this.selectedIndex].value;
        },
        false
      );
      toolbar.toolbar.append(select);
    },
    replacePreviewTabClass: function(toolbar) {
      toolbar.previewTab.childNodes[0].classList.remove('tab-preview');
      toolbar.previewTab.childNodes[0].classList.add('pwfmt-preview');
    },
    overrideHidePreview: function(toolbar) {
      toolbar.hidePreview = function(event) {
        if (event.target.classList.contains('selected')) {
          return;
        }
        this.toolbar.classList.remove('hidden');
        this.textarea.classList.remove('hidden');
        this.preview.classList.add('hidden');
        this.tabsBlock
          .getElementsByClassName('pwfmt-preview')[0]
          .classList.remove('selected');
        event.target.classList.add('selected');
      };
    }
  };
}

$(document).ready(function() {
  $('#content').on('click', 'div.jstTabs a.pwfmt-preview', function(event) {
    var tab = $(event.target);

    var url = tab.data('url');
    var form = tab.parents('form');
    var jstBlock = tab.parents('.jstBlock');

    var element = encodeURIComponent(jstBlock.find('.wiki-edit').val());
    var attachments = form.find('.attachments_fields input').serialize();

    var format = jstBlock.find('.pwfmt-select').val();

    $.ajax({
      url: url,
      type: 'post',
      data: 'pwfmt_format=' + format + '&text=' + element + '&' + attachments,
      success: function(data) {
        jstBlock.find('.wiki-preview').html(data);
      }
    });
  });
});
