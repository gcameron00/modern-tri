/* =========================================================================
   Modern Triathlon — main.js
   Small, dependency-free progressive enhancements:
     1. Mobile nav toggle
     2. Scroll-reveal animations (IntersectionObserver)
     3. Current year in the footer
   The site works fully without JS; this only adds polish.
   ========================================================================= */
(function () {
  "use strict";

  /* --------------------------- Mobile nav -------------------------------- */
  var toggle = document.querySelector(".nav-toggle");
  var links = document.getElementById("nav-links");

  if (toggle && links) {
    toggle.addEventListener("click", function () {
      var open = links.classList.toggle("open");
      toggle.setAttribute("aria-expanded", String(open));
    });

    // Close the menu after tapping a link (mobile)
    links.addEventListener("click", function (e) {
      if (e.target.closest("a")) {
        links.classList.remove("open");
        toggle.setAttribute("aria-expanded", "false");
      }
    });
  }

  /* ------------------------- Scroll reveal ------------------------------- */
  var revealables = document.querySelectorAll(".reveal");
  var prefersReduced = window.matchMedia(
    "(prefers-reduced-motion: reduce)"
  ).matches;

  if (prefersReduced || !("IntersectionObserver" in window)) {
    // Show everything immediately if motion is reduced or unsupported.
    revealables.forEach(function (el) {
      el.classList.add("is-visible");
    });
  } else {
    var observer = new IntersectionObserver(
      function (entries, obs) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            obs.unobserve(entry.target);
          }
        });
      },
      { rootMargin: "0px 0px -10% 0px", threshold: 0.12 }
    );

    revealables.forEach(function (el) {
      observer.observe(el);
    });
  }

  /* --------------------------- Footer year ------------------------------- */
  var yearEl = document.querySelector("[data-year]");
  if (yearEl) {
    yearEl.textContent = String(new Date().getFullYear());
  }
})();
