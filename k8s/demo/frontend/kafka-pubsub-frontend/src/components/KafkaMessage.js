import React from 'react';
import Topicos from "./Topicos";
//'use strict';
class KafkaMessage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      topicos: [],
      id: '',
      titulo: '',
      mensagem: '',
      dataCriacao: ''
    };
    this.create = this.create.bind(this);
    this.update = this.update.bind(this);
    this.delete = this.delete.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }
  
  fetchTopicos(){
    fetch("http://192.168.0.10:8080/topicos", {
      method: "GET",
      headers: {
         "Accept": "application/json, text/plain, */*",
      }
    })
    .then(response => response.json())
    .then(response => {
      this.setState({
        topicos: response
      })
    })
    .catch(err => { console.log(err); 
    }); 
  }

  componentDidMount() {
    this.fetchTopicos();
  }


  create(e) {
    // add entity - POST
    e.preventDefault();
    
    // creates entity
    fetch("http://192.168.0.10:8080/topicos", {
      "method": "POST",
      "headers": {
        "content-type": "application/json",
        "accept": "application/json"
      },
      "body": JSON.stringify({
        titulo: this.state.titulo,
        mensagem: this.state.mensagem,
        dataCriacao: this.state.dataCriacao
      })
    })
    .then(response => response.json())
    .then(response => {
      console.log(response)
    })
    .catch(err => {
      console.log(err);
    });

    this.fetchTopicos();
  }


  update(e) {
    // update entity - PUT
    e.preventDefault();
    
    // this will update entries with PUT
    fetch(`http://192.168.0.10:8080/topicos/${this.state.id}`, {
      "method": "PUT",
      "headers": {
        "content-type": "application/json",
        "accept": "application/json"
      },
      "body": JSON.stringify({
        id: this.state.id,
        titulo: this.state.titulo,
        mensagem: this.state.mensagem,
        dataCriacao: this.state.dataCriacao
      })
    })
    .then(response => response.json())
    .then(response => { console.log(response);
    })
    .catch(err => { console.log(err); });
    this.fetchTopicos();
  }

  delete(e) {
    // delete entity - DELETE
    e.preventDefault();

    // deletes entities
    fetch(`http://192.168.0.10:8080/topicos/${this.state.id}`, {
      "method": "DELETE",
      "headers": {
        "content-type": "application/json",
        "accept": "application/json"
      }
    })
    .then(response => response.json())
    .then(response => { console.log(response)
    .then(this.setState({id: ''}) );
    })
    .catch(err => { console.log(err); });

    this.fetchTopicos();
  }


  handleChange(changeObject) {
    this.setState(changeObject)
  }

  render() {
    return (
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-8">
              <h1 className="display-4 text-center">Make An API Call in React</h1>
              <form className="d-flex flex-column">
                <legend className="text-center">Add-Update-Delete Friend</legend>
                <label htmlFor="ID">
                  ID:
                  <input
                    name="id"
                    id="id"
                    type="number"
                    className="form-control"
                    value={this.state.id}
                    onChange={(e) => this.handleChange({ id: e.target.value })}
                    />
                </label>
                <label htmlFor="titulo">
                  Titulo:
                  <input
                    name="titulo"
                    id="titulo"
                    type="text"
                    className="form-control"
                    value={this.state.titulo}
                    onChange={(e) => this.handleChange({ titulo: e.target.value })}
                    required
                    />
                </label>
                <label htmlFor="mensagem">
                  Mensagem:
                  <input
                    name="mensagem"
                    id="notes"
                    type="test"
                    className="form-control"
                    value={this.state.mensagem}
                    onChange={(e) => this.handleChange({ mensagem: e.target.value })}
                    required
                    />
                </label>
                <label htmlFor="dataCriacao">
                  Data Criação:
                  <input
                    name="dataCriacao"
                    id="dataCriacao"
                    type="date"
                    className="form-control"
                    value={this.state.dataCriacao}
                    onChange={(e) => this.handleChange({ dataCriacao: e.target.value })}
                    />
                </label>
                <button className="btn btn-primary" type='button' onClick={(e) => this.create(e)}>
                  Add
                </button>
                <button className="btn btn-info" type='button' onClick={(e) => this.update(e)}>
                    Update
                </button>
                <button className="btn btn-danger" type='button' onClick={(e) => this.delete(e)}>
                    Delete
                </button>
                <Topicos topicos={this.state.topicos} />
              </form>
            </div>
          </div>
        </div>
    );
  }
}
//let domContainer = document.querySelector('#KafkaMessage');
//ReactDOM.render(<KafkaMessage />, domContainer);
export default KafkaMessage;