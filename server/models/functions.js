var pool = require("./connection");

module.exports.registerPessoa = async function (
  nome,
  email,
  pass
) {
  try {
    var sql = "SELECT * FROM pessoa WHERE pessoa_email =?";
    let result = await pool.query(sql, [email]);
    if (result.length > 0)
      return { status: 401, result: { msg: "Já está registado" } };
    else {
      var sql = 'insert into pessoa (pessoa_nome, pessoa_email,pessoa_pass) VALUES (?,?,?)';
      let result = await pool.query(sql, [
        nome,
        email,
        pass
      ])
      return { status: 200, result: { msg: "registado com sucesso" } };;
    }
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
};

module.exports.loginPessoa = async function (email, pass) {
  try {
    let sql = "SELECT * from pessoa Where pessoa.pessoa_email = ? AND pessoa.pessoa_pass = ? ";
    let result = await pool.query(sql, [email, pass]);
    if (result.length > 0) return { status: 200, result: result[0] };
    else return { status: 401, result: { msg: "Wrong email or password" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
};

module.exports.inscricaoPessoa = async function (rotaId , inscricaoPessoaId) {
  try {
      var sql1 = 'select * from inscricao where inscricao_assign_id = ? AND inscricao_pessoa_id = ? '
      let result = await pool.query(sql1, [inscricaoPessoaId , rotaId]);
      if(result.length > 0) return { status: 401, result: { msg: "Já participou" } };
      else {
      var sql = 'insert into inscricao (inscricao_assign_id, inscricao_pessoa_id) values (?,?)';
      let result = await pool.query(sql, [inscricaoPessoaId , rotaId])
      return { status: 200, result: { msg: "Inscrito com sucesso" } };;
      }
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
};


module.exports.GetHistorico = async function (PessoaId) {
  try {
    let sql = "SELECT inscricao.inscricao_pessoa_id , rota.rota_nome from inscricao INNER JOIN assign ON inscricao.inscricao_assign_id = assign.assign_id INNER JOIN rota ON assign.assign_rota_id = rota.rota_id AND inscricao_pessoa_id = ?;"
    let result = await pool.query(sql, [PessoaId]);
    console.log(PessoaId);
    return { status: 200, result: result };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
};

module.exports.GetProfileById = async function(PessoaId) {
    try {
        let sql = "select * from pessoa where pessoa_id = ?";
        let result = await pool.query(sql,[PessoaId]);
        if (result.length > 0)  
            return {status: 200, result: result[0] };
        else return {status: 404, result: {msg: "Pessoa not found!"}};
    } catch(err) {
        console.log(err);
        return {status:500, result: err};
    }
};  

module.exports.getAllArtes = async function () {
  try {
    let sql = "Select * from artes";
    let result = await pool.query(sql);
    let artes = result;
    return { status: 200, result: artes };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
};

module.exports.getAllPessoas = async function () {
  try {
    let sql = "Select * from pessoa";
    let result = await pool.query(sql);
    let pessoa = result;
    return { status: 200, result: pessoa };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
};

module.exports.getAllRotas = async function () {
  try {
    let sql = "Select * from rota";
    let result = await pool.query(sql);
    let rota = result;
    return { status: 200, result: rota };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getAllAutores = async function () {
  try {
    let sql = "Select * from autor";
    let result = await pool.query(sql);
    let autores = result;
    return { status: 200, result: autores };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getArtesRotas = async function(rotaId) {
  try {
      let sql = "SELECT artes_id from artes_rota where rota_id = ?";
      let result = await pool.query(sql,[rotaId]);
      console.log(rotaId);
      return {status: 200, result: result };
  } catch(err) {
      console.log(err);
      return {status:500, result: err};
  }

} 
