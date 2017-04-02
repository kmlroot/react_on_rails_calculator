import React from 'react';
const uuidV1 = require('uuid/v1');

export default class Project extends React.Component {
  constructor(props, _railsContext) {
    super(props);
    this.state = {
      payments: null
    };
  }

  onSubmit = (e) => {
    e.preventDefault();

    fetch('/simulations', {
      method: 'post',
      credentials: 'same-origin',
      headers: new Headers({
        'Content-Type': 'application/json'
      }),
      body: JSON.stringify({
        simulation: {
          project_id: this.projectsInput.value,
          interest: this.interestInput.value,
          fee: this.feeInput.value
        }
      })
    })
    .then(response => response.json())
    .then((payments) => {
      this.setState({
        payments: payments
      });
    });
  }

  render() {
    const {user, projects} = this.props;

    return (
      <div>
        <div className="container">
          <div className="row">
            <div className="simulate-box">
              <h2 className="align-middle">{user.name} - ${user.budget}</h2>
              <form onSubmit={(e) => this.onSubmit(e)}>
                <div className="form-group">
                  <label htmlFor="projects" className="sr-only">Projects</label>
                  <div className="input-group">
                    <select className="form-control" id="projects" ref={(input) => this.projectsInput = input}>
                      {
                        projects.map((project) => {
                          return (
                            <option key={project.id} value={project.id}>{project.name}</option>
                          )
                        })
                      }
                    </select>
                  </div>
                </div>

                <div className="form-group">
                  <label htmlFor="tasa">Tasa de interes anual</label>
                  <div className="input-group">
                    <div className="input-group-addon"><i className="fa fa-key" aria-hidden="true"></i></div>
                    <input id="tasa" className="form-control" type="text" ref={(input) => this.interestInput = input}></input>
                  </div>
                </div>

                <div className="form-group">
                  <label htmlFor="tasa">Nº cuotas</label>
                  <div className="input-group">
                    <div className="input-group-addon"><i className="fa fa-key" aria-hidden="true"></i></div>
                    <input id="cuotas" className="form-control" type="text" ref={(input) => this.feeInput = input}></input>
                  </div>
                </div>


                <div className="input-row">
                  <button type="submit" className="btn btn-lg btn-block btn-send">Simular Credito</button>
                </div>
              </form>
            </div>
          </div>
        </div>
        {
          this.state.payments ?
          <Payments payments={this.state.payments} />
          : <span></span>
        }
      </div>
    );
  }
}

class Payments extends React.Component {
  render() {
    const {payments} = this.props;

    return (
      <div className="payments">
        <table className="table table-bordered">
          <thead className="thead-inverse">
            <tr>
              <th>Nº cuota</th>
              <th>Valor a pagar</th>
              <th>Fecha</th>
            </tr>
          </thead>
          <tbody>
            {
              payments.map((payment) => {
                return (
                  <tr key={uuidV1()}>
                    <td>{payment.period}</td>
                    <td>${payment.loan_remaining}</td>
                    <td>{payment.fetcha}</td>
                  </tr>
                );
              })
            }
          </tbody>
        </table>
      </div>
    )
  }
}
