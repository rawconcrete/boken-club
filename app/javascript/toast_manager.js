// // app/javascript/toast_manager.js
// contents were moved to application.js due to deployment issues
// class ToastManager {
//   constructor() {
//     this.containerId = 'toast-container';
//     this.zIndex = 1050;
//     // Wait until DOM is loaded to set up container
//     if (document.readyState === 'loading') {
//       document.addEventListener('DOMContentLoaded', () => this.setupContainer());
//     } else {
//       this.setupContainer();
//     }
//     this.toasts = [];
//   }

//   // Make sure bootstrap is available
//   ensureBootstrap() {
//     return new Promise((resolve) => {
//       const checkBootstrap = () => {
//         if (window.bootstrap) {
//           resolve(window.bootstrap);
//         } else {
//           setTimeout(checkBootstrap, 50);
//         }
//       };
//       checkBootstrap();
//     });
//   }

//   async show(message, options = {}) {
//     // Make sure bootstrap is loaded before showing toast
//     await this.ensureBootstrap();
//     const defaults = {
//       type: 'success',
//       title: '',
//       autoHide: true,
//       delay: 10000, // Increased from 5000 to 8000 (8 seconds)
//       // toast timing
//       icon: true,
//       animation: true
//     };

//     const settings = { ...defaults, ...options };

//     // Create toast element
//     const toastId = `toast-${Date.now()}`;
//     const toast = document.createElement('div');
//     toast.id = toastId;
//     toast.className = `toast ${settings.animation ? 'fade' : ''} bg-white border-${settings.type}`;
//     toast.style.borderLeftWidth = '4px';
//     toast.setAttribute('role', 'alert');
//     toast.setAttribute('aria-live', 'assertive');
//     toast.setAttribute('aria-atomic', 'true');

//     // Get appropriate icon based on type
//     let iconClass = '';
//     switch (settings.type) {
//       case 'success':
//         iconClass = 'fa-check-circle text-success';
//         break;
//       case 'warning':
//         iconClass = 'fa-exclamation-triangle text-warning';
//         break;
//       case 'danger':
//         iconClass = 'fa-exclamation-circle text-danger';
//         break;
//       case 'info':
//       default:
//         iconClass = 'fa-info-circle text-info';
//         break;
//     }

//     // Create toast content
//     toast.innerHTML = `
//       <div class="toast-header">
//         ${settings.icon ? `<i class="fas ${iconClass} me-2"></i>` : ''}
//         <strong class="me-auto">${settings.title || this.getDefaultTitle(settings.type)}</strong>
//         <small class="text-muted">${this.getTimeLabel()}</small>
//         <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
//       </div>
//       <div class="toast-body">
//         ${message}
//       </div>
//     `;

//     // Add to container
//     this.container.appendChild(toast);

//     // Initialize bootstrap toast
//     const bsToast = new bootstrap.Toast(toast, {
//       autohide: settings.autoHide,
//       delay: settings.delay
//     });

//     // Show the toast
//     bsToast.show();

//     // Store reference for management
//     const toastData = { id: toastId, element: toast, instance: bsToast };
//     this.toasts.push(toastData);

//     // Setup auto-removal when hidden
//     toast.addEventListener('hidden.bs.toast', () => {
//       // Remove from DOM
//       this.container.removeChild(toast);

//       // Remove from our tracking array
//       const index = this.toasts.findIndex(t => t.id === toastId);
//       if (index !== -1) {
//         this.toasts.splice(index, 1);
//       }
//     });

//     return toastData;
//   }

//   getDefaultTitle(type) {
//     switch (type) {
//       case 'success': return 'Success!';
//       case 'warning': return 'Warning!';
//       case 'danger': return 'Error!';
//       case 'info': return 'Information';
//       default: return 'Notification';
//     }
//   }

//   getTimeLabel() {
//     // Return current time in HH:MM format
//     const now = new Date();
//     return `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`;
//   }

//   // Convenience methods for common toast types
//   success(message, options = {}) {
//     return this.show(message, { ...options, type: 'success' });
//   }

//   info(message, options = {}) {
//     return this.show(message, { ...options, type: 'info' });
//   }

//   warning(message, options = {}) {
//     return this.show(message, { ...options, type: 'warning' });
//   }

//   error(message, options = {}) {
//     return this.show(message, { ...options, type: 'danger' });
//   }

//   // Clear all toasts
//   clear() {
//     // Create a copy to avoid modification issues during iteration
//     const toastsCopy = [...this.toasts];
//     toastsCopy.forEach(toast => {
//       toast.instance.hide();
//     });
//   }
// }

// // Create a global instance
// window.toastManager = new ToastManager();

// export default window.toastManager;
