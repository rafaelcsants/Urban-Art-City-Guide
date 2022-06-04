var express = require("express");
var router = express.Router();
var mProd = require("../models/functions.js");

router.get("/", async function (req, res, next) {
    let result = await mProd.getAllArtes();
    res.status(result.status).send(result.result);
  });

  router.get("/byRota/:rotaId", async function (req, res, next) {
  let rotaId = req.params.rotaId
  let result = await mProd.getArtesRotas(rotaId);
  res.status(result.status).send(result.result);
  });

router.get("/proximos", async function (req, res, next) {
  let lat  = req.query.lat; 
  let long = req.query.long;
  console.log(lat, long)
  let result = await mProd.getAllCentrosProximos(lat, long);
  res.status(result.status).send(result.result);
  });

  module.exports = router;
