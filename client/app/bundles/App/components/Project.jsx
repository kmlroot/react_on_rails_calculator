import React from 'react';

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
          tasa: this.tasaInput.value,
          cuotas: this.cuotasInput.value
        }
      })
    }).
    then(response => response.json()).
    then((payments) => {
      this.setState({
        payments: payments
      });
    });
  }

  render() {
    const {user, projects} = this.props;

    console.log(projects)

    return (
      <div>
        <div className="simulation">
          <h2>{user.name} ${user.budget}</h2>
          <form onSubmit={(e) => this.onSubmit(e)}>
            <div className="input-row">
              <label htmlFor="projects">Projects:</label>
              <select id="projects" ref={(input) => this.projectsInput = input}>
                {
                  projects.map((project) => {
                    return (
                      <option key={project.id} value={project.id}>{project.name}</option>
                    )
                  })
                }
              </select>
            </div>
            <div className="input-row">
              <label htmlFor="tasa">Tasa de interest</label>
              <input id="tasa" type="text" ref={(input) => this.tasaInput = input}></input>
            </div>
            <div className="input-row">
              <label htmlFor="cuotas">No Cuotas</label>
              <input id="cuotas" type="text" ref={(input) => this.cuotasInput = input}></input>
            </div>
            <div className="input-row">
              <button type="submit">Simular Credito</button>
            </div>
          </form>
        </div>
        {
          this.state.payments ?
          <Payments payments={this.state.payments} />
          : <div>Choose a project.</div>
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
        <table>
          <thead>
            <tr>
              <th>Cuota</th>
              <th>Valor</th>
              <th>Fetcha</th>
            </tr>
          </thead>
          <tbody>
            {
              payments.map((payment) => {
                return (
                  <tr>
                    <td>{payment.cuota}</td>
                    <td>${payment.valor}</td>
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
