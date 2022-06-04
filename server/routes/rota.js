var express = require("express");
var router = express.Router();
var mProd = require("../models/functions.js");

router.get("/", async function (req, res, next) {
    let result = await mProd.getAllRotas();
    res.status(result.status).send(result.result);
  });

  module.exports = router;
  