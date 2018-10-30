// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require tether
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .


document.addEventListener("turbolinks:load", function() {
  (function() {


    // Definition of caller element
    var getTriggerElement = function(el) {
      var isCollapse = el.getAttribute('data-collapse');
      if (isCollapse !== null) {
        return el;
      } else {
        var isParentCollapse = el.parentNode.getAttribute('data-collapse');
        return (isParentCollapse !== null) ? el.parentNode : undefined;
      }
    };

    // A handler for click on toggle button
    var collapseClickHandler = function(event) {
      var triggerEl = getTriggerElement(event.target);
      // If trigger element does not exist
      if (triggerEl === undefined) {
        event.preventDefault();
        return false;
      }

      // If the target element exists
      var targetEl = document.querySelector(triggerEl.getAttribute('data-target'));
      if (targetEl) {
        triggerEl.classList.toggle('-active');
        targetEl.classList.toggle('-on');
      }
    };


    // Delegated event
    document.getElementById("toggle-sticks").addEventListener('click', collapseClickHandler, false);

  })(document, window);
});