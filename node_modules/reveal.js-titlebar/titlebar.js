/**
 * A plugin which adds the presentation title to the presentation.
 *
 * @author sedrubal
 *
 */
var RevealTitleBar = window.RevealTitleBar || (function(){

  var default_title = [];
  if (document.querySelector('meta[name=author]') !== undefined) {
    default_title.push(document.querySelector('meta[name=author]').content);
  }
  if (document.getElementsByTagName('title').length >= 1) {
    default_title.push(document.getElementsByTagName('title')[0].innerText);
  }

  var options = Reveal.getConfig().titlebar || {};
  options.title = options.title || default_title.join([separator = ' - ']);

  // create breadcrumb bar
  var title_bar = document.createElement('div');
  title_bar.classList.add('title-bar');
  document.getElementsByClassName('reveal')[0].appendChild(title_bar);

  title_bar.innerHTML = options.title;

})();
