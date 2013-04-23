$(function () {
	$(document).on('click', '#restaurants th a', function () {
    $.getScript(this.href);
    return false;
  });

  $('.mention_highlight').popover({ html: true});
});
