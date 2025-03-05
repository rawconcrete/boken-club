// app/javascript/application.js
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import toastManager from "./toast_manager"

// Make toast manager available globally for direct access from controllers
window.showToast = function(message, type = 'info', options = {}) {
  return toastManager.show(message, { ...options, type });
};

// start travel plan form partial, to populate adventures
document.addEventListener('turbo:load', function() {
  // adventure filter functionality
  const adventureFilter = document.getElementById('adventure-filter');
  if (adventureFilter) {
    console.log("Adventure filter found");

    // check if adventures are already loaded
    const checkAndLoadAdventures = function() {
      const adventureResults = document.querySelector('[data-travel-plan-target="adventureResults"]');
      if (adventureResults && adventureResults.children.length === 0) {
        console.log("No adventures found, attempting to load them");

        // make direct fetch request for adventures
        fetch('/adventures.json')
          .then(response => response.json())
          .then(adventures => {
            console.log(`Loaded ${adventures.length} adventures directly`);

            // manually render adventures
            if (adventures.length > 0) {
              const adventureHtml = adventures.map(adventure => {
                const adventureData = JSON.stringify(adventure).replace(/"/g, '&quot;');
                return `
                  <div class="list-group-item d-flex justify-content-between align-items-center">
                    ${adventure.name}
                    <button type="button"
                            class="btn btn-sm btn-primary"
                            data-action="click->travel-plan#selectAdventure"
                            data-adventure="${adventureData}">
                      Add
                    </button>
                  </div>
                `;
              }).join('');

              adventureResults.innerHTML = adventureHtml;
              console.log("Adventures rendered manually");
            }
          })
          .catch(error => {
            console.error("Error fetching adventures:", error);
            adventureResults.innerHTML = `<div class="alert alert-danger">Error loading adventures: ${error.message}</div>`;
          });
      }
    };

    // run the check immediately
    setTimeout(checkAndLoadAdventures, 500);

    // set up the filter functionality
    adventureFilter.addEventListener('input', function() {
      const filterValue = this.value.toLowerCase();
      const adventureItems = document.querySelectorAll('[data-travel-plan-target="adventureResults"] .list-group-item');

      if (adventureItems.length === 0) {
        checkAndLoadAdventures();
        return;
      }

      console.log(`Filtering ${adventureItems.length} adventures with value: ${filterValue}`);

      adventureItems.forEach(item => {
        const adventureName = item.textContent.trim().toLowerCase();
        if (adventureName.includes(filterValue)) {
          item.style.display = '';
        } else {
          item.style.display = 'none';
        }
      });
    });
  }
});
// end travel plan form partial, to populate adventures
