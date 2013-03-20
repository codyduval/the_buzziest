$(function () {
	$(document).on('click', '#restaurants th a', function () {
    $.getScript(this.href);
    return false;
  });
})
