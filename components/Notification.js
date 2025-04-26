import { useEffect, useState } from 'react';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

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