Reveal.js Titlebar Plugin
=========================

Titlebar plugin for reveal.js
-----------------------------

Adds a bar containing author and title to the bottom of the slides.

Usage
-----

 - Install with npm, yarn or bower: `(npm install|yarn add|bower install) reveal.js-titlebar`
 - Add `<title>The Power of Reveal.js</title>` to the head of your presentation
 - Add `<meta name="author" content="John Doe" />` to the head of your presentation
 - Add `{ src: 'titlebar/titlebar.js', async: true },` to the dependencies section
 - Add `<link rel="stylesheet" href="titlebar/titlebar.css">`
 - Overwrite default title: Add this to reveal.js initialization block:

```js
titlebar: {
  title: 'Foo Title'
},
```

Example
-------

![example screenshot](./titlebar_example.png)

License
-------

[GPLv3](https://www.gnu.org/licenses/gpl.html)
