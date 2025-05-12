import React from 'react';
import { useParams } from 'react-router-dom';

interface ModuleTemplateProps {
  title: string;
  description?: string;
  children: React.ReactNode;
}

export const ModuleTemplate: React.FC<ModuleTemplateProps> = ({
  title,
  description,
  children,
}) => {
  const { id } = useParams();

  return (
    <div className="module-container">
      <header className="module-header">
        <h1>{title}</h1>
        {description && <p className="module-description">{description}</p>}
      </header>
      <main className="module-content">
        {children}
      </main>
    </div>
  );
};

export default ModuleTemplate; 