import React, { useEffect, useState } from "react";

export const Modal = ({ show, onClose, children, color }) => {
  const [isBrowser, setIsBrowser] = useState(false);

  useEffect(() => {
    setIsBrowser(true);
  }, []);

  const handleCloseClick = (e) => {
    e.preventDefault();
    onClose();
  };

  const modalContent = show ? (
    <div className="modal-frame">
      <div className={`modal couleur ${color}`}>
          <div className="modal-header">
              <a href="#" onClick={handleCloseClick}>
              x
              </a>
          </div>
          <div className="mt-10">
              {children}
          </div>
      </div>
    </div>
  ) : null;

  return modalContent
};

