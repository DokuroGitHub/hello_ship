require("dotenv").config();
const express = require("express");
const http = require("http");
const https = require("https");
const cors = require("cors");
const bodyParser = require("body-parser");
const fetch = require("node-fetch");
const url = require("url");
const nodemailer = require("nodemailer");
const transporter = nodemailer.createTransport(
  "smtp://" +
    process.env.SMTP_LOGIN +
    ":" +
    process.env.SMTP_PASSWORD +
    "@" +
    process.env.SMTP_HOST
);
const fs = require("fs");
const path = require("path");
const postgraphile = require("./postgraphile");
const db = require("./database");
const jwt = require("express-jwt");
const jwksRsa = require("jwks-rsa");

// de bat ssl trong database.js
//process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0;
const PORT_HTTP = parseInt(process.env.PORT_HTTP, 10) || 3000;
const PORT_HTTPS = parseInt(process.env.PORT_HTTPS, 10) || 3001;

var jwtCheck = jwt({
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
    jwksUri: "https://dev-4q6howh8.us.auth0.com/.well-known/jwks.json",
  }),
  audience: "https://dokuro-postgraphile/api",
  issuer: "https://dev-4q6howh8.us.auth0.com/",
  algorithms: ["RS256"],
});

const authErrors = (err, req, res, next) => {
  if (err.name === "UnauthorizedError") {
    console.log("err");
    console.log(err);
    res.status(err.status).json({ errors: [{ message: err.message }] });
    res.end();
  }
};

const app = express();
app.use("/", express.static(path.join(__dirname, "public")));
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(function (req, res, next) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Cache-Control", "no-cache");
  next();
});

var AUTH0_MANAGEMENT_API_TOKEN_FROM_MACHINE_TO_MACHINE_DESU = "chua_co_token";

const getAuth0ManagementApiTokenFromMachineToMachineApi = async () => {
  console.log("getAuth0ManagementApiTokenFromMachineToMachineApi");
  // get AUTH0_MANAGEMENT_API_TOKEN from Machine to Machine API
  var body_desu = {
    client_id: process.env.MACHINE_TO_MACHINE_CLIENT_ID,
    client_secret: process.env.MACHINE_TO_MACHINE_CLIENT_SECRET,
    audience: "https://" + process.env.AUTH0_DOMAIN + "/api/v2/",
    grant_type: "client_credentials",
  };
  var options = {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body_desu),
  };
  console.log("data");
  const response = await fetch(
    "https://" + process.env.AUTH0_DOMAIN + "/oauth/token",
    options
  );
  const data = await response.json();
  console.log("data");
  console.log(data);
  AUTH0_MANAGEMENT_API_TOKEN_FROM_MACHINE_TO_MACHINE_DESU = data.access_token;
  console.log(
    "AUTH0_MANAGEMENT_API_TOKEN_FROM_MACHINE_TO_MACHINE_DESU: " +
      AUTH0_MANAGEMENT_API_TOKEN_FROM_MACHINE_TO_MACHINE_DESU
  );
  return data.access_token;
};

getAuth0ManagementApiTokenFromMachineToMachineApi();

const getProfileInfo = (user_id) => {
  console.log("getProfileInfo");
  //access_token_desu = process.env.AUTH0_MANAGEMENT_API_TOKEN;
  const headers = {
    Authorization:
      "Bearer " + AUTH0_MANAGEMENT_API_TOKEN_FROM_MACHINE_TO_MACHINE_DESU,
  };
  console.log(headers);
  return fetch(
    "https://" + process.env.AUTH0_DOMAIN + "/api/v2/users/" + user_id,
    { headers: headers }
  ).then((response) => response.json());
};

app.post("/auth0", async (req, res) => {
  console.log("/auth0");
  const { session_variables } = req.body;
  const user_id = session_variables["x-hasura-user-id"];
  console.log("user_id: " + user_id);
  // make a rest api call to auth0
  const data = await getProfileInfo(user_id);
  console.log("data");
  console.log(data);
  if (!data) {
    return res.status(400).json({
      message: "error happened",
    });
  }
  return res.json({
    id: data.user_id,
    email: data.email,
    picture: data.picture,
  });
});

app.get("/auth/login", (req, res) => {
  console.log("/auth/login");
  var params_desu = {
    response_type: "code",
    audience: "https://dokuro-postgraphile/api",
    client_id: process.env.SINGLE_PAGE_CLIENT_ID,
    connection: "Username-Password-Authentication",
    redirect_uri:
      "http://" +
      process.env.THIS_PROJECT_DOMAIN +
      ":" +
      PORT_HTTP +
      "/auth/login_signup_success",
  };

  var my_url = url.format({
    pathname: "https://" + process.env.AUTH0_DOMAIN + "/authorize",
    query: params_desu,
  });
  console.log("my_url: " + my_url);
  res.redirect(my_url);
});

app.get("/auth/login_signup_success", async (req, res) => {
  console.log("/auth/login_signup_success");
  console.log(req.query);
  var AUTHORIZATION_CODE_DESU = req.query.code;
  console.log("AUTHORIZATION_CODE_DESU: " + AUTHORIZATION_CODE_DESU);

  const params = new URLSearchParams({
    grant_type: "authorization_code",
    client_id: process.env.SINGLE_PAGE_CLIENT_ID,
    client_secret: process.env.SINGLE_PAGE_CLIENT_SECRET,
    code: AUTHORIZATION_CODE_DESU,
    redirect_uri:
      "http://" +
      process.env.THIS_PROJECT_DOMAIN +
      ":" +
      PORT_HTTP +
      "/useless_callback_afgfdgsdgdsfgsfsd",
  });

  var options = {
    method: "POST",
    body: params,
  };

  const response = await fetch(
    "https://" + process.env.AUTH0_DOMAIN + "/oauth/token",
    options
  );
  const data = await response.json();
  console.log("data");
  console.log(data);
  return res.json(data);
});

app.post("/send_email", function (req, res) {
  console.log("/send_email");
  const name = req.body.event.data.new.name;
  // setup e-mail data
  const mailOptions = {
    from: process.env.SENDER_ADDRESS, // sender address
    to: process.env.RECEIVER_ADDRESS, // list of receivers
    subject: "A new user has registered", // Subject line
    text:
      "Hi, This is to notify that a new user has registered under the name of " +
      name, // plaintext body
    html:
      "<p>" +
      "Hi, This is to notify that a new user has registered under the name of " +
      name +
      "</p>", // html body
  };
  // send mail with defined transport object
  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      return console.log(error);
    }
    console.log("Message sent: " + info.response);
    res.json({ success: true });
  });
});

app.get("/users", db.getUsers);
app.get("/users2", async (req, res) => {
  var results = await db.getUsers2();
  res.status(200).json(results);
});

// Apply checkJwt to our graphql endpointapp.use('/graphql', checkJwt);
app.use('/graphql', jwtCheck);
//app.use(jwtCheck);
// Apply error handling to the graphql endpoint
app.use('/graphql', authErrors);
//app.use(authErrors);

app.use(postgraphile);

//app.listen(PORT_HTTP, () => console.log(`Server running on port ${PORT_HTTP}`));

var httpsOptions = {
  pfx: fs.readFileSync("./cert.pfx"),
  passphrase: "dovt58",
};

//var io = require('socket.io').listen(server); // Mapping socket with server

http.createServer(app).listen(PORT_HTTP, () => {
  console.log("server http is runing at port " + PORT_HTTP);
});

https.createServer(httpsOptions, app).listen(PORT_HTTPS, () => {
  console.log("server https is runing at port " + PORT_HTTPS);
});

// localhost:808/auth/login_signup_with_redirect
// https://localhost:8081/auth/login_signup_with_redirect
