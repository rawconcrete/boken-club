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

// travel plan show js
// we could add this to a new file: app/javascript/travel_plans_show.js

document.addEventListener('turbo:load', function() {
  // check if we're on the travel plan show page
  if (document.querySelector('.travel-plan-show')) {

    // find all existing flash messages and convert them to toasts
    const flashMessages = document.querySelectorAll('.flash-message, .alert:not(.alert-dismissible)');

    if (flashMessages.length > 0) {
      flashMessages.forEach(message => {
        // get message type from class
        let type = 'info';
        if (message.classList.contains('alert-success')) type = 'success';
        if (message.classList.contains('alert-warning')) type = 'warning';
        if (message.classList.contains('alert-danger')) type = 'danger';

        // get message content
        const content = message.innerHTML;

        // show as toast
        if (window.toastManager) {
          window.toastManager.show(content, { type });
        }

        // hide the original message
        message.style.display = 'none';
      });
    }

    // check for the "all equipment owned" condition and show a toast
    const equipmentToBuy = document.querySelector('.equipment-to-buy');
    if (equipmentToBuy && equipmentToBuy.querySelectorAll('.card').length === 0) {
      const ownedEquipment = document.querySelector('.equipment-to-pack');

      if (ownedEquipment && ownedEquipment.querySelectorAll('.card').length > 0) {
        // show a success toast if the user owns all equipment
        if (window.toastManager) {
          window.toastManager.success(
            "You already own all the equipment needed for this trip!",
            {
              title: "Great News!",
              delay: 8000
            }
          );
        }
      }
    }

    // setup click handler for purchase buttons
    document.querySelectorAll('.btn-purchase-equipment').forEach(button => {
      button.addEventListener('click', function(event) {
        // get equipment name from data attribute or nearby element
        const equipmentName = this.getAttribute('data-equipment-name') ||
                             this.closest('.card').querySelector('.card-title').textContent.trim();

        // show a loading toast while the request is processing
        let loadingToast;
        if (window.toastManager) {
          loadingToast = window.toastManager.show(
            `Marking ${equipmentName} as purchased...`,
            {
              type: 'info',
              autoHide: false
            }
          );
        }

        // add custom success handling to show toast
        const originalSuccess = this.dataset.success;
        if (originalSuccess) {
          // store original success handler if needed
        }

        // we'll let the controller handle the actual AJAX call
        // just make sure to add the needed toast display in the success callback
      });
    });
  }
});

// also export the toast manager so it can be imported directly
export { default as toastManager } from './toast_manager';
// end travel plan show js
