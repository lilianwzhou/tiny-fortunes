import "./App.css";
import Login from "./components/login/Login";
import { BrowserRouter, Route, Switch } from "react-router-dom";
import Dashboard from "./components/dashboard/Dashboard";
import useToken from "./hooks/useToken";
import CustomNavBar from "./components/navbar/CustomNavBar";
import UserList from "./components/users/UserList";
import CreateFortune from "./components/createFortune/CreateFortune";

function App() {
  const { token, setToken } = useToken();

  console.log(token);
  if (!token) {
    return <Login setToken={setToken} />;
  }

  return (
    <div className="App">
      <CustomNavBar setToken={setToken}></CustomNavBar>
      <BrowserRouter>
        <Switch>
          <Route path="/users">
            <UserList token={token}></UserList>
          </Route>
          <Route path="/fortune/create">
            <CreateFortune token={token}></CreateFortune>
          </Route>
          <Route path="/">
            <Dashboard></Dashboard>
          </Route>
        </Switch>
      </BrowserRouter>
    </div>
  );
}

export default App;
