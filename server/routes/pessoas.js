var express = require("express");
var router = express.Router();
var mProd = require("../models/functions");
const cors = require("cors")

router.post('/login',async function(req, res, next) {
  let email = req.body.email;
  let password = req.body.pass;
  let result = await mProd.loginPessoa(email,password);
  res.status(result.status).send(result.result);
});

router.post('/register',async function(req, res, next) {
  let nome = req.body.nome;
  let email = req.body.email;
  let pass = req.body.pass;
  let result = await mProd.registerPessoa(nome,email,pass);
  res.status(result.status).send(result.result);
});

router.post('/inscricao',async function(req, res, next) {
  let pessoaId = req.body.pessoaId;
  let rotaId = req.body.rotaId;
  let result = await mProd.inscricaoPessoa(pessoaId,rotaId);
  res.status(result.status).send(result.result);
});

router.get("/", async function (req, res, next) {
  let result = await mProd.getAllPessoas();
  res.status(result.status).send(result.result);
});

router.get("/autores", async function (req, res, next) {
  let result = await mProd.getAllAutores();
  res.status(result.status).send(result.result);
});

router.get("/historico/:pessoaId", async function (req, res, next) {
  let pessoaId = req.params.pessoaId
  let result = await mProd.GetHistorico(pessoaId);
  res.status(result.status).send(result.result);
});

module.exports = router;
