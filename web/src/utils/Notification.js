import { createContext, useContext, useState, useEffect } from 'react';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const NotificationContext = createContext();

export function NotificationProvider({ children }) {
  const [notifications, setNotifications] = useState([]);

  const addNotification = (message, type = 'info', duration = 5000) => {
    const id = Date.now();
    setNotifications(prev => [...prev, { id, message, type }]);

    if (duration > 0) {
      setTimeout(() => {
        removeNotification(id);
      }, duration);
    }
  };

  const removeNotification = (id) => {
    setNotifications(prev => prev.filter(notification => notification.id !== id));
  };

  return (
    <NotificationContext.Provider value={{ addNotification }}>
      {children}
      <div className="notification-container">
        {notifications.map(notification => (
          <div
            key={notification.id}
            className={`notification ${notification.type}`}
          >
            <div className="notification-content">
              {notification.message}
            </div>
            <button
              className="notification-close"
              onClick={() => removeNotification(notification.id)}
            >
              ×
            </button>
          </div>
        ))}
      </div>
    </NotificationContext.Provider>
  );
}

export function useNotification() {
  const context = useContext(NotificationContext);
  if (!context) {
    throw new Error('useNotification must be used within a NotificationProvider');
  }
  return context;
}

export const Notification = ({ message, type = 'info', duration = 3000 }) => {
  useEffect(() => {
    if (message) {
      switch (type) {
        case 'success':
          toast.success(message, { autoClose: duration });
          break;
        case 'error':
          toast.error(message, { autoClose: duration });
          break;
        case 'warning':
          toast.warning(message, { autoClose: duration });
          break;
        default:
          toast.info(message, { autoClose: duration });
      }
    }
  }, [message, type, duration]);

  return (
    <ToastContainer
      position="bottom-right"
      autoClose={duration}
      hideProgressBar={false}
      newestOnTop
      closeOnClick
      rtl={false}
      pauseOnFocusLoss
      draggable
      pauseOnHover
      theme="light"
    />
  );
};

export const showNotification = (message, type = 'info', duration = 3000) => {
  switch (type) {
    case 'success':
      toast.success(message, { autoClose: duration });
      break;
    case 'error':
      toast.error(message, { autoClose: duration });
      break;
    case 'warning':
      toast.warning(message, { autoClose: duration });
      break;
    default:
      toast.info(message, { autoClose: duration });
  }
}; 