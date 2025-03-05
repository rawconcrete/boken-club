// app/javascript/application.js
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import toastManager from "../javascript/toast_manager"

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
  // Only run on the travel plan show page
  if (!document.querySelector('.travel-plan-show')) return;

  // Wait a short moment to ensure all other scripts have run
  setTimeout(() => {
    initializeToasts();
  }, 100);

  // Set up equipment purchase handlers
  setupEquipmentPurchaseHandlers();
});

function initializeToasts() {
  // Check for the toast manager
  if (!window.toastManager) {
    console.warn('Toast manager not available. Notifications may not display correctly.');
    return;
  }

  // Convert any flash messages to toasts
  convertFlashMessagesToToasts();

  // Show the "you own all equipment" message if applicable
  checkIfAllEquipmentOwned();

  // Show checklist completion messages if applicable
  checkChecklistCompletion();
}

function convertFlashMessagesToToasts() {
  // Find all flash messages
  const flashMessages = document.querySelectorAll('.alert:not(.loading-indicator)');

  if (flashMessages.length === 0) return;

  flashMessages.forEach(message => {
    // Get message type from class
    let type = 'info';
    if (message.classList.contains('alert-success')) type = 'success';
    if (message.classList.contains('alert-warning')) type = 'warning';
    if (message.classList.contains('alert-danger')) type = 'danger';

    // Get message content (without close button)
    let content = message.innerHTML;
    const closeButton = message.querySelector('.btn-close');
    if (closeButton) {
      closeButton.remove();
      content = message.innerHTML;
    }

    // Show as toast
    window.toastManager.show(content, {
      type: type,
      autoHide: true,
      delay: 6000
    });

    // Hide the original message
    message.style.display = 'none';
  });
}

function checkIfAllEquipmentOwned() {
  // Check if there's a "to buy" section that's empty
  const equipmentToBuy = document.querySelector('.equipment-to-buy');
  const equipmentToPack = document.querySelector('.equipment-to-pack');

  if (!equipmentToBuy || !equipmentToPack) return;

  const hasToBuyItems = equipmentToBuy.querySelectorAll('.card').length > 0;
  const hasToPackItems = equipmentToPack.querySelectorAll('.card').length > 0;

  // If there are items to pack but none to buy, show the "own all" message
  if (!hasToBuyItems && hasToPackItems) {
    window.toastManager.success(
      "You already own all the equipment needed for this trip!",
      {
        title: "Great News!",
        delay: 8000
      }
    );
  }
}

function checkChecklistCompletion() {
  // Check if all checkboxes are checked
  const allCheckboxes = document.querySelectorAll('input[type="checkbox"][data-checklist-item]');
  const completedCheckboxes = document.querySelectorAll('input[type="checkbox"][data-checklist-item]:checked');

  if (allCheckboxes.length === 0) return;

  const completionPercentage = Math.round((completedCheckboxes.length / allCheckboxes.length) * 100);

  // Show different messages based on completion percentage
  if (completionPercentage === 100) {
    window.toastManager.success(
      "You've completed your entire packing checklist! You're ready for your adventure!",
      {
        title: "All Set!",
        delay: 6000
      }
    );
  } else if (completionPercentage >= 80) {
    window.toastManager.info(
      `You're ${completionPercentage}% packed for your trip! Almost there!`,
      {
        title: "Making Progress!",
        delay: 5000
      }
    );
  }
}

function setupEquipmentPurchaseHandlers() {
  // Find all purchase buttons
  const purchaseButtons = document.querySelectorAll('.btn-purchase-equipment');

  purchaseButtons.forEach(button => {
    button.addEventListener('click', function(event) {
      // Get equipment name
      const equipmentName = this.getAttribute('data-equipment-name') ||
                           this.closest('.card')?.querySelector('.card-title')?.textContent.trim() ||
                           "this item";

      // Show a loading toast
      const loadingToast = window.toastManager.show(
        `Marking ${equipmentName} as purchased...`,
        {
          type: 'info',
          autoHide: false,
          title: 'Processing'
        }
      );

      // The actual AJAX request is handled by Rails UJS or your own code
      // We just need to update the success/error handling

      // Listen for completion of the request
      const originalClickHandler = this.onclick;
      this.onclick = null;

      this.addEventListener('ajax:success', function(event) {
        // Hide the loading toast
        if (loadingToast && loadingToast.instance) {
          loadingToast.instance.hide();
        }

        // Show the success toast
        window.toastManager.success(
          `${equipmentName} has been marked as purchased and added to your equipment.`,
          {
            title: 'Purchase Successful!',
            delay: 5000
          }
        );

        // Optionally auto-update the UI if needed
        setTimeout(() => {
          window.location.reload();
        }, 1000);
      });

      this.addEventListener('ajax:error', function(event) {
        // Hide the loading toast
        if (loadingToast && loadingToast.instance) {
          loadingToast.instance.hide();
        }

        // Show the error toast
        window.toastManager.error(
          `Failed to mark ${equipmentName} as purchased. Please try again.`,
          {
            title: 'Error',
            delay: 8000
          }
        );
      });
    });
  });
}

// Export the toast manager so it can be imported directly
export { default as toastManager } from './toast_manager';
