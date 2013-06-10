$(function () {
	$(document).on('click', '#restaurants th a', function () {
    $.getScript(this.href);
    event.preventDefault();
  });

  $('.mention_highlight').popover({ html: true});
});
