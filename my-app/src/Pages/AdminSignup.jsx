import  { useState } from "react";
import "./Login.css";
import key from "../assets/mdkey.png";
import email from "../assets/email.png";
import user from "../assets/user.png";
import Input from "../Components/input";
import useInput from "../Components/input-hook";
import { NavLink, useNavigate } from "react-router-dom";
import google from "../assets/google1.png";
import Windowresponsiv from "../Components/Windowresponsiv";
import { GoogleOAuthProvider, GoogleLogin } from "@react-oauth/google";
import { useDispatch } from "react-redux";
import { authActions } from "../store/authSlice";
import api from "../api/api";
const AdminSignup = () => {
  const { width } = Windowresponsiv();
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const {
    value: enteredName,
    isValid: enteredNameIsValid,
    hasError: enteredNameHasError,
    valueChangeHandler: nameChangeHandler,
    inputBlurHandler: nameBlurHandler,
    resetValue: resetNameValue,
  } = useInput((value) => value.trim() !== "");

  const {
    value: enteredEmail,
    isValid: enteredEmailIsValid,
    hasError: enteredEmailHasError,
    valueChangeHandler: emailChangeHandler,
    inputBlurHandler: emailBlurHandler,
    resetValue: resetEmailValue,
  } = useInput((value) => value.includes("@"));

  const {
    value: enteredPassword,
    isValid: enteredPasswordIsValid,
    hasError: enteredPasswordHasError,
    valueChangeHandler: passwordChangeHandler,
    inputBlurHandler: passwordBlurHandler,
    resetValue: resetPasswordValue,
  } = useInput((value) => value.trim().length > 6);

  const {
    value: confirmEnteredPassword,
    isValid: confirmEnteredPasswordIsValid,
    hasError: confirmEnteredPasswordHasError,
    valueChangeHandler: confirmPasswordChangeHandler,
    inputBlurHandler: confirmPasswordBlurHandler,
    resetValue: resetConfirmPasswordValue,
  } = useInput((value) => value.trim().length > 6 && value === enteredPassword);
  const [loading, setLoading] = useState(false); // Loading state for the API call

  const submitHandler = async (e) => {
    e.preventDefault();

    const userData = {
      fullName: enteredName,
      email: enteredEmail,
      password: enteredPassword,
      passwordConfirm: confirmEnteredPassword,
    };
    try {
      setLoading(true);
      const response = await api.post("/freelancers/register", userData);
      alert("Registration successful!");
      // Reset form
      resetNameValue();
      resetEmailValue();
      resetPasswordValue();
      resetConfirmPasswordValue();
    } catch (error) {
    } finally {
      setLoading(false);
    }
  };
  const handleGoogleSuccess = async (response) => {
    try {
      const res = await api.post("/freelancers/auth/google/register", {
        token: response.credential, // Send Google token to the backend
      });
      if (res.status === 200) {
        console.log(res);
        const { email, fullName, _id, role } = res.data.data.user;
        const name = fullName;
        dispatch(authActions.login({ email, name, _id, role }));
        console.log("navigating to home");
        navigate("/");
      }
    } catch (error) {}
  };
  const handleGoogleFailure = (error) => {};
  return (
    <GoogleOAuthProvider clientId="664999914369-t8udl75vmjfughnd95here6ak2bd3jf4.apps.googleusercontent.com">
     
      <div className="registrationContainer">
        <h2 className="title">
          Admin Registration
        </h2>
        <form onSubmit={submitHandler}>
          <div className="gridContainer">
            <Input
              type="text"
              id="fullName"
              name="fullName"
              label="Full Name"
              placeholder="Abebe Bekila"
              value={enteredName}
              onChange={nameChangeHandler}
              onBlur={nameBlurHandler}
              hasError={enteredNameHasError}
              icon={<img src={user} alt="" width={20} height={20} />}
              required
            />
            <Input
              type="email"
              id="email"
              name="email"
              label="Email"
              placeholder="abebe@gmail.com"
              value={enteredEmail}
              onChange={emailChangeHandler}
              onBlur={emailBlurHandler}
              hasError={enteredEmailHasError}
              icon={
                <img
                  src={email}
                  alt=""
                  width={width > 414 ? 17 : 23}
                  height={width > 414 ? 16 : 18}
                />
              }
              required
            />
            <Input
              type="password"
              id="password"
              name="password"
              label="Password"
              placeholder="*************"
              value={enteredPassword}
              onChange={passwordChangeHandler}
              onBlur={passwordBlurHandler}
              hasError={enteredPasswordHasError}
              icon={
                <img
                  src={key}
                  alt=""
                  width={width > 414 ? 23 : 30}
                  height={width > 414 ? 12 : 18}
                />
              }
              isVisible
              required
            />
            <Input
              type="password"
              id="confirmPassword"
              name="confirmPassword"
              label="Confirm Password"
              placeholder="**************"
              value={confirmEnteredPassword}
              onChange={confirmPasswordChangeHandler}
              onBlur={confirmPasswordBlurHandler}
              hasError={confirmEnteredPasswordHasError}
              icon={
                <img
                  src={key}
                  alt=""
                  width={width > 414 ? 23 : 30}
                  height={width > 414 ? 12 : 18}
                />
              }
              required
            />
          </div>

         
          <div className="">
            <button type="submit" className="registerButton" disabled={loading}>
              {loading ? "Registering..." : "Register"}
            </button>
            <p className="loginOption">
              Already have an account? <NavLink to="/">Login</NavLink>
            </p>
          </div>

          <div className="divider">OR CONTINUE WITH</div>

          <div className="google">
            <img src={google} alt="" className="icon" />
            <GoogleLogin
              onSuccess={handleGoogleSuccess}
              onError={handleGoogleFailure}
              useOneTap
              text="continue_with"
            />
          </div>
        </form>
      </div>
    </GoogleOAuthProvider>
  );
};

export default AdminSignup;
