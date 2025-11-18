import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { MODULES } from '../config/constants';

interface NavigationProps {
  className?: string;
}

export const Navigation: React.FC<NavigationProps> = ({ className = '' }) => {
  const navigate = useNavigate();
  const location = useLocation();

  const handleNavigation = (path: string) => {
    navigate(path);
  };

  return (
    <nav className={`navigation ${className}`}>
      {Object.values(MODULES).map((module) => (
        <a
          key={module.path}
          href={module.path}
          className={`nav-link ${location.pathname === module.path ? 'active' : ''}`}
          onClick={(e) => {
            e.preventDefault();
            handleNavigation(module.path);
          }}
        >
          <i className={`icon-${module.icon}`}></i>
          <span>{module.name}</span>
        </a>
      ))}
    </nav>
  );
};

export default Navigation; 