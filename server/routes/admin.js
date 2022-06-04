var express = require("express");
var router = express.Router();
var mProd = require("../models/functions");

  router.get('/:id', async function(req, res, next) {
    let AdminId = req.params.id;
    console.log("Sending Admin Profile with id "+AdminId);
    let result = await mProd.GetAdminProfileById(AdminId);
    res.status(result.status).send(result.result);
  });

  router.get("/", async function (req, res, next) {
    let result = await mProd.getAllAdmins();
    res.status(result.status).send(result.result);
  });

  router.put("/aceitarMonitor", async function (req, res, next){
  let monitorId = req.body.pessoa_id;
  console.log("Monitor Profile updated with id "+monitorId);
  let result = await mProd.aceitarMonitor(monitorId);
  res.status(result.status).send(result.result);
  });


  router.get("/:id/pedidosMonitor", async function (req, res, next) {
    let result = await mProd.pedidosMonitor();
    res.status(result.status).send(result.result);
  });

  router.post(`/:id/gerirMonitor`, async function (req, res, next) {
    let semana = req.body.semana;
    let monitor = req.body.monitor;
    let campo = req.body.campo;
    console.log("Monitor updated with id "+monitor);
    let result = await mProd.gerirMonitor(semana, monitor, campo);
    res.status(result.status).send(result.result);
  });

  module.exports = router;
