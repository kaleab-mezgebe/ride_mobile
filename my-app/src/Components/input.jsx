import React, { useState } from "react";
import styles from "./input.module.css";
// import eye from "../../assets/eye.png";
// import { MdVisibility, MdVisibilityOff } from "react-icons/md";
const Input = ({
  id,
  label,
  type,
  name,
  value,
  placeholder,
  isVisible,
  hasError,
  onBlur,
  onChange,
  icon,
  domainIcon,
  required,
}) => {
  const [showPassword, setShowPassword] = useState(false);
  const togglePasswordVisibility = () => {
    setShowPassword((prev) => !prev);
  };
  const inputType =
    isVisible && type === "password" && showPassword ? "text" : type;
  // const iconContainerType = width <= 414 && fromContact;
  return (
    <>
      {/* Password */}
      <div
        className={`${styles.inputGroup} ${hasError ? styles.invalid : ""} ${
          name === "password" ? styles.inputGroupForPassword : ""
        }`}
      >
        <label htmlFor={id} className={styles.inputLabel}>
          {label} {required && <span className={styles.required}>*</span>}
        </label>
        <div className={styles.inputWrapper}>
          <div
            className={`${styles.iconContainer} ${
              domainIcon ? styles.prefix : ""
            }`}
          >
            {domainIcon === undefined ? icon : domainIcon}
          </div>
          <input
            type={inputType}
            id={id}
            name={name}
            placeholder={placeholder}
            className={styles.inputField}
            value={value}
            onBlur={onBlur}
            onChange={onChange}
          />
          {isVisible && (
            <span
              onClick={togglePasswordVisibility}
              className={styles.eyeIconContainer}
            >
              {/* {showPassword ? (
                <MdVisibility className={styles.eyeIcon} />
              ) : (
                <MdVisibilityOff className={styles.eyeIcon} />
              )} */}
            </span>
          )}
        </div>
      </div>
    </>
  );
};

export default Input;