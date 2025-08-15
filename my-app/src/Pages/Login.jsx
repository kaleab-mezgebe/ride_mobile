import { useState } from "react";
import "./Login.css";
import key from "../assets/mdkey.png";
import email from "../assets/email.png";
import enter from "../assets/enter.png";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import { useDispatch } from "react-redux";
import { authActions } from "../store/authSlice";
import Input from "../Components/input"; // two levels up to src
import google from "../assets/google1.png";
import Windowresponsiv from "../Components/Windowresponsiv";
import { GoogleOAuthProvider, GoogleLogin } from "@react-oauth/google";
import api from "../api/api";
import { setError } from "../store/errorSlice";
const Login = () => {
  const location = useLocation();
  const Redirectpath = location.state?.path || "/";
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const [values, setValues] = useState({
    email: "",
    password: "",
    isChecked: false,
  });
  const InputChangeHandler = (event) => {
    const { name, value, type, checked } = event.target;
    setValues((prevValues) => ({
      ...prevValues,
      [name]: type === "checkbox" ? checked : value,
    }));
  };
  const submitHandler = async (event) => {
    event.preventDefault();
    try {
      const res = await api.post("/auth/login", values, {});
      if (res.status === 200) {
        console.log(res);
        const { email, fullName, _id, companyName, role } = res.data.data.user;
        const token = res.data.token;
        const name = role === "company" ? companyName : fullName;
        dispatch(
          authActions.login({ email, name, fullName, _id, token, role })
        );
        navigate(Redirectpath, { replace: true });
      }
    } catch (error) {}
  };
  const { width } = Windowresponsiv();
  const handleGoogleSuccess = async (response) => {
    try {
      const res = await api.post("/auth/google/login", {
        token: response.credential,
      });
      if (res.status === 200) {
        const { email, fullName, _id, companyName, role } = res.data.data.user;
        const name = role === "company" ? companyName : fullName;
        dispatch(authActions.login({ email, name, _id, role }));
        navigate("/Dashboard");
      }
    } catch (error) {}
  };
  const handleGoogleFailure = (error) => {
    dispatch(setError("login failed!"));
  };

  return (
    <div className="registrationContainer">
      <h2 className="title">
        <img src={enter} alt="" width={45} height={45} />
        Login
      </h2>
      <GoogleOAuthProvider clientId="664999914369-t8udl75vmjfughnd95here6ak2bd3jf4.apps.googleusercontent.com">
        <form onSubmit={submitHandler}>
          <div className="gridContainer">
            <Input
              type="email"
              id="email"
              name="email"
              label="Email:"
              placeholder="abebebekila@gmail.com"
              value={values.email}
              onChange={InputChangeHandler}
              icon={
                <img
                  src={email}
                  alt=""
                  width={width > 414 ? 17 : 23}
                  height={width > 414 ? 16 : 18}
                />
              }
            />
            <Input
              type="password"
              id="password"
              name="password"
              label="Password:"
              placeholder="************"
              value={values.password}
              onChange={InputChangeHandler}
              isVisible={true}
              icon={
                <img
                  src={key}
                  alt=""
                  width={width > 414 ? 23 : 30}
                  height={width > 414 ? 12 : 18}
                />
              }
            />
          </div>
          <div className="checkboxLabel">
            <input
              type="checkbox"
              id="terms"
              name="isChecked"
              className="checkbox"
              checked={values.isChecked}
              onChange={InputChangeHandler}
            />
            <label htmlFor="terms">Remember me next time.</label>
          </div>
          <div className="authOption">
            <p className="loginOption">
              Forgot Password?{" "}
              <NavLink to="/Resetpassword" className="highlight">
                Reset
              </NavLink>
            </p>
            <button type="submit" className="registerButton">
              Login
            </button>
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
      </GoogleOAuthProvider>
    </div>
  );
};

export default Login;
