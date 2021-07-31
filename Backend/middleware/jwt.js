import jwt from "jsonwebtoken";

export class AuthMiddleware {
  static sharedInstance;

  static shared() {
    if (!AuthMiddleware.sharedInstance) {
      AuthMiddleware.sharedInstance = new AuthMiddleware();
    }
    return AuthMiddleware.sharedInstance;
  }

  validateAuth(req, res, next) {
    if (req.headers["authorization"]) {
      try {
        let authorization = req.headers["authorization"].split(" ");
        if (authorization[0] !== "Bearer") {
          return res.status(401).send("No Auth Token Supplied");
        } else {
          if (authorization[1] === process.env.ADMIN_KEY) {
            req.isAdmin = true;
            next();
            return;
          }

          req.jwt = jwt.verify(authorization[1], process.env.JWT_SECRET);
          req.isAdmin = req.jwt.isAdmin;
          console.log(req.jwt);
          next();
        }
      } catch (err) {
        console.log(err);
        return res.status(403).send(err);
      }
    } else {
      return res.status(401).send("No Auth Token Supplied");
    }
  }

  sameUserOrAdmin(req, res, next) {
    if (req.isAdmin && req.isAdmin === true) {
      return next();
    }
    let userID = req.jwt.userID;
    if (req.params && req.params.userID && userID === req.params.userID) {
      return next();
    } else {
      return res.status(403).send({});
    }
  }

  adminOnly(req, res, next) {
    if (req.isAdmin && req.isAdmin === true) {
      return next();
    } else {
      return res.status(403).send({});
    }
  }

  requireClientKey(req, res, next) {
    console.log(req.headers);
    console.log(req.headers["authorization-client"]);
    if (req.headers["authorization-client"]) {
      try {
        let authorization = req.headers["authorization-client"].split(" ");
        if (authorization[0] !== "Basic") {
          return res.status(401).send("No Client Token Supplied");
        } else {
          if (authorization[1] === process.env.CLIENT_KEY) {
            return next();
          } else {
            return res.status(403).send("Invalid Client Key");
          }
        }
      } catch (err) {
        console.log(err);
        return res.status(403).send(err);
      }
    } else {
      return res.status(401).send("No Client Token Supplied");
    }
  }
}
